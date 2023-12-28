// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PriceFeedConsumer} from "./interface/PriceFeed.sol";

///

contract MarketiOlliN is Ownable {
    constructor() Ownable(msg.sender) {}

    event crowCreated(address indexed crow, string projectId);

    function createCrow(
        string memory _baseURI,
        uint256 _price,
        uint256 _totalSupply,
        address _entrepreneur,
        string memory _projectId
    ) public {
        address newCrow = address(
            new IOlliN(
                _entrepreneur,
                _price,
                _totalSupply,
                _baseURI,
                address(0xc2132D05D31c914a87C6611C10748AEb04B58e8F),
                address(0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6),
                address(0xb9Df42070b0D20074CC666c58005c1511903350B),
                address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619),
                address(this)
            )
        );

        //emit event
        emit crowCreated(newCrow, _projectId);
    }

    function withdraw() public {
        require(msg.sender == owner(), "Only the entrepreneur can withdraw");

        require(address(this).balance > 0, "No balance to withdraw");
        payable(owner()).transfer(address(this).balance);
        ///transfer erc20 tokens
        IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F).transfer(
            owner(),
            IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F).balanceOf(
                address(this)
            )
        );
        IERC20(0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6).transfer(
            owner(),
            IERC20(0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6).balanceOf(
                address(this)
            )
        );
        IERC20(0xb9Df42070b0D20074CC666c58005c1511903350B).transfer(
            owner(),
            IERC20(0xb9Df42070b0D20074CC666c58005c1511903350B).balanceOf(
                address(this)
            )
        );
        IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619).transfer(
            owner(),
            IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619).balanceOf(
                address(this)
            )
        );
    }
}
////////////////////////////////////// ERC1155 //////////////////////////////////////
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract IOlliN is ERC1155, Ownable, ReentrancyGuard {
    ////@dev state variables
    uint256 price;
    uint256 totalSupply;
    uint256 sold;
    address entrepreneur;
    uint256 timestamp;
    string baseURI;

    // tokens prices contract
    PriceFeedConsumer public PricesContract;

    address public feeAddress;
    uint256 public constant FEE_PERCENTAGE = 7;

    IERC20 private ERC20Usdt;
    IERC20 private ERC20WBTC;
    IERC20 private ERC20ION;
    IERC20 private ERC20WETH;

    ////@dev events
    event NftMinted(
        uint256 indexed requestId,
        address requester,
        uint256 amount,
        string token
    );

    ////@dev constructor
    constructor(
        address _entrepreneur,
        uint256 _price,
        uint256 _totalSupply,
        string memory _URI,
        address _ERC20Usdt,
        address _ERC20WBTC,
        address _ERC20ION,
        address _ERC20WETH,
        address _feeAddress
    ) Ownable(_entrepreneur) ERC1155(_URI) {
        price = _price;
        totalSupply = _totalSupply;
        sold = 0;
        feeAddress = _feeAddress;
        entrepreneur = _entrepreneur;
        baseURI = _URI;
        ERC20Usdt = IERC20(_ERC20Usdt);
        ERC20WBTC = IERC20(_ERC20WBTC);
        ERC20ION = IERC20(_ERC20ION);
        ERC20WETH = IERC20(_ERC20WETH);
        PricesContract = PriceFeedConsumer(
            0x30F396A426036dA0b2346185d3c1a19D78f86F13
        );
    }

    ////@dev mint functions

    function mintUSDT(uint _quantity, address _to) external {
        uint256 amountInMatic = priceInUSDT(_quantity);

        require(
            ERC20Usdt.allowance(msg.sender, address(this)) >= amountInMatic,
            "You must approve ERC20 to the contract first"
        );
        require(
            ERC20Usdt.balanceOf(msg.sender) >= amountInMatic,
            "Not enough money"
        );

        require(sold < totalSupply, "Crow is sold out");
        require(sold + _quantity <= totalSupply, "There are not so many nfts");

        ///transfer ERC20
        bool transferSuccessful = ERC20Usdt.transferFrom(
            msg.sender,
            address(this),
            amountInMatic
        );

        require(transferSuccessful, "ERC20 transfer failed"); // check if the transfer was successful or not and revert if it failed
        _mint(_to, sold, _quantity, "");
        emit NftMinted(timestamp, msg.sender, _quantity, "USDT");
        sold += _quantity;
    }

    // function mintWBTC(uint _quantity, address _to) external {
    //     uint256 amountInMatic = priceInBTC(_quantity);
    //     require(
    //         ERC20WBTC.allowance(msg.sender, address(this)) >= amountInMatic,
    //         "You must approve ERC20 to the contract first"
    //     );
    //     require(
    //         ERC20WBTC.balanceOf(msg.sender) >= amountInMatic,
    //         "Not enough money"
    //     );
    //     require(sold < totalSupply, "Crow is sold out");
    //     require(sold + _quantity <= totalSupply, "There are not so many nfts");

    //     ///transfer ERC20
    //     bool transferSuccessful = ERC20WBTC.transferFrom(
    //         msg.sender,
    //         address(this),
    //         amountInMatic
    //     );

    //     require(transferSuccessful, "ERC20 transfer failed"); // check if the transfer was successful or not and revert if it failed
    //     _mint(_to, sold, _quantity, "");

    //     emit NftMinted(timestamp, msg.sender, _quantity, "BTC");
    //     sold += _quantity;
    // }

    function mintWETH(uint256 _quantity, address _to) external {
        uint256 amountInETH = priceInETH(_quantity);

        require(
            ERC20WETH.allowance(msg.sender, address(this)) >= amountInETH,
            "You must approve ERC20 to the contract first"
        );
        require(
            ERC20WETH.balanceOf(msg.sender) >= amountInETH,
            "Not enough money"
        );
        require(sold < totalSupply, "Crow is sold out");
        require(sold + _quantity <= totalSupply, "There are not so many nfts");

        ///transfer ERC20
        bool transferSuccessful = ERC20WETH.transferFrom(
            msg.sender,
            address(this),
            amountInETH
        );

        require(transferSuccessful, "ERC20 transfer failed"); // check if the transfer was successful or not and revert if it failed
        _mint(_to, sold, _quantity, "");
        emit NftMinted(timestamp, msg.sender, _quantity, "WETH");
        sold += _quantity;
    }

    function mint(uint _quantity, address _to) external payable {
        uint256 amountInMatic = priceInMatic(_quantity);
        require(msg.value >= amountInMatic, "Not enough money");
        require(sold < totalSupply, "Crow is sold out");
        require(sold + _quantity <= totalSupply, "There are not so many nfts");

        _mint(_to, sold, _quantity, "");
        emit NftMinted(timestamp, msg.sender, _quantity, "MATIC");

        sold += _quantity;
    }

    // function mintIOLLIN(int _quantity, address _to) external {
    //     require(
    //         ERC20ION.allowance(msg.sender, address(this)) >=
    //             usdPrice * _quantity,
    //         "You must approve ERC20 to the contract first"
    //     );
    //     require(
    //         ERC20ION.balanceOf(msg.sender) >= usdPrice * _quantity,
    //         "Not enough money"
    //     );
    //     require(sold < totalSupply, "Crow is sold out");
    //     require(sold + _quantity <= totalSupply, "There are not so many nfts");

    //     ///transfer ERC20
    //     bool transferSuccessful = ERC20ION.transferFrom(
    //         msg.sender,
    //         address(this),
    //         usdPrice * _quantity
    //     );

    //     require(transferSuccessful, "ERC20 transfer failed"); // check if the transfer was successful or not and revert if it failed
    //     _mint(_to, sold, _quantity, "");
    //     sold += _quantity;
    // }

    function _baseURI() internal view returns (string memory) {
        return baseURI;
    }

    function calculateFee(uint256 amount) internal pure returns (uint256) {
        return (amount * FEE_PERCENTAGE) / 100;
    }

    function withdraw() public {
        require(
            msg.sender == entrepreneur,
            "Only the entrepreneur can withdraw"
        );

        require(address(this).balance > 0, "No balance to withdraw");

        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No balance to withdraw");

        uint256 feeAmount = calculateFee(contractBalance);
        uint256 feeWETH = calculateFee(ERC20WETH.balanceOf(address(this)));
        uint256 feeUSDT = calculateFee(ERC20Usdt.balanceOf(address(this)));
        uint256 entrepreneurAmount = contractBalance - feeAmount;
        uint256 entrepreneurWETH = ERC20WETH.balanceOf(address(this)) - feeWETH;
        uint256 entrepreneurUSDT = ERC20Usdt.balanceOf(address(this)) - feeUSDT;
        ///transfer erc20 tokens
        ERC20WETH.transfer(feeAddress, feeWETH);
        ERC20Usdt.transfer(feeAddress, feeUSDT);
        ERC20WETH.transfer(entrepreneur, entrepreneurWETH);
        ERC20Usdt.transfer(entrepreneur, entrepreneurUSDT);
        payable(feeAddress).transfer(feeAmount);
        payable(entrepreneur).transfer(entrepreneurAmount);
    }

    // function priceInBTC(uint256 _quantity) public view returns (uint256) {
    //     uint256 BTCPriceInUSD = PricesContract.getLatestPriceBTC(); /// bitcoin price in usd
    //     uint256 nftCostInBitcoin = (price * 1e8) / BTCPriceInUSD;
    //     return nftCostInBitcoin * _quantity;
    // }

    function priceInETH(uint256 _quantity) public view returns (uint256) {
        uint256 ETHPriceInUSD = PricesContract.getLatestPriceETH(); /// bitcoin price in usd
        uint256 nftCostInETH = (price * 1e18) / ETHPriceInUSD;
        return nftCostInETH * _quantity;
    }

    function priceInUSDT(uint256 _quantity) public view returns (uint256) {
        return price * _quantity;
    }

    function priceInMatic(uint256 _quantity) public view returns (uint256) {
        uint256 MATICPriceInUSD = PricesContract.getLatestPriceMATIC(); /// price in usd
        uint256 nftCostInMATIC = (price * 1e18) / MATICPriceInUSD;
        return nftCostInMATIC * _quantity;
    }
}
