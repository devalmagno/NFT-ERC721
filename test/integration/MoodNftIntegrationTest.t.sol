// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    string constant NFT_NAME = "MoodNFT";
    string constant NFT_SYMBOL = "MOOD";
    address public constant USER = address(1);
    MoodNft public moodNft;
    string public constant HAPPY_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    string public constant SAD_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBmaWxsPSIjMzMzIiBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIvPjxwYXRoIGZpbGw9IiNFNkU2RTYiIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiLz48cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPjwvc3ZnPg==";
    string public constant SAD_MOOD_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZE5GVCIsImRlc2NyaXB0aW9uIjoiQW4gTkZUIHRoYXQgcmVmbGVjdHMgdGhlIG1vb2Qgb2YgdGhlIG93bmVyLCAxMDAlIG9uIENoYWluISIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6Ik1vb2QiLCJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlNVEF5TkhCNElpQm9aV2xuYUhROUlqRXdNalJ3ZUNJZ2RtbGxkMEp2ZUQwaU1DQXdJREV3TWpRZ01UQXlOQ0lnZUcxc2JuTTlJbWgwZEhBNkx5OTNkM2N1ZHpNdWIzSm5Mekl3TURBdmMzWm5JajRLSUNBZ0lEeHdZWFJvSUdacGJHdzlJaU16TXpNaUNpQWdJQ0FnSUNBZ1pEMGlUVFV4TWlBMk5FTXlOalF1TmlBMk5DQTJOQ0F5TmpRdU5pQTJOQ0ExTVRKek1qQXdMallnTkRRNElEUTBPQ0EwTkRnZ05EUTRMVEl3TUM0MklEUTBPQzAwTkRoVE56VTVMalFnTmpRZ05URXlJRFkwZW0wd0lEZ3lNR010TWpBMUxqUWdNQzB6TnpJdE1UWTJMall0TXpjeUxUTTNNbk14TmpZdU5pMHpOeklnTXpjeUxUTTNNaUF6TnpJZ01UWTJMallnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUlETTNNbm9pSUM4K0NpQWdJQ0E4Y0dGMGFDQm1hV3hzUFNJalJUWkZOa1UySWdvZ0lDQWdJQ0FnSUdROUlrMDFNVElnTVRRd1l5MHlNRFV1TkNBd0xUTTNNaUF4TmpZdU5pMHpOeklnTXpjeWN6RTJOaTQySURNM01pQXpOeklnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUxURTJOaTQyTFRNM01pMHpOekl0TXpjeWVrMHlPRGdnTkRJeFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEazJJREFnTkRndU1ERWdORGd1TURFZ01DQXdJREV0T1RZZ01IcHRNemMySURJM01tZ3RORGd1TVdNdE5DNHlJREF0Tnk0NExUTXVNaTA0TGpFdE55NDBRell3TkNBMk16WXVNU0ExTmpJdU5TQTFPVGNnTlRFeUlEVTVOM010T1RJdU1TQXpPUzR4TFRrMUxqZ2dPRGd1Tm1NdExqTWdOQzR5TFRNdU9TQTNMalF0T0M0eElEY3VORWd6TmpCaE9DQTRJREFnTUNBeExUZ3RPQzQwWXpRdU5DMDROQzR6SURjMExqVXRNVFV4TGpZZ01UWXdMVEUxTVM0MmN6RTFOUzQySURZM0xqTWdNVFl3SURFMU1TNDJZVGdnT0NBd0lEQWdNUzA0SURndU5IcHRNalF0TWpJMFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEQXRPVFlnTkRndU1ERWdORGd1TURFZ01DQXdJREVnTUNBNU5ub2lJQzgrQ2lBZ0lDQThjR0YwYUNCbWFXeHNQU0lqTXpNeklnb2dJQ0FnSUNBZ0lHUTlJazB5T0RnZ05ESXhZVFE0SURRNElEQWdNU0F3SURrMklEQWdORGdnTkRnZ01DQXhJREF0T1RZZ01IcHRNakkwSURFeE1tTXRPRFV1TlNBd0xURTFOUzQySURZM0xqTXRNVFl3SURFMU1TNDJZVGdnT0NBd0lEQWdNQ0E0SURndU5HZzBPQzR4WXpRdU1pQXdJRGN1T0MwekxqSWdPQzR4TFRjdU5DQXpMamN0TkRrdU5TQTBOUzR6TFRnNExqWWdPVFV1T0MwNE9DNDJjemt5SURNNUxqRWdPVFV1T0NBNE9DNDJZeTR6SURRdU1pQXpMamtnTnk0MElEZ3VNU0EzTGpSSU5qWTBZVGdnT0NBd0lEQWdNQ0E0TFRndU5FTTJOamN1TmlBMk1EQXVNeUExT1RjdU5TQTFNek1nTlRFeUlEVXpNM3B0TVRJNExURXhNbUUwT0NBME9DQXdJREVnTUNBNU5pQXdJRFE0SURRNElEQWdNU0F3TFRrMklEQjZJaUF2UGdvOEwzTjJaejQ9In0=";

    modifier mintNft() {
        vm.prank(USER);
        moodNft.mintNft();
        _;
    }

    function setUp() public {
        DeployMoodNft deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testFlipTokenToSad() public mintNft {
        vm.prank(USER);
        moodNft.flipMood(0);

        assertEq(moodNft.tokenURI(0), SAD_MOOD_URI);
    }
}