class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://ghfast.top/https://github.com/argotorg/solidity/releases/download/v0.8.37/solidity_0.8.37.tar.gz"
  sha256 "705306af6d6e0f4da04b4de7be22a5d7b87a90af0901170e726d8d97b342fcf8"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7005723a3aaaf1be56416ff2148593fd563664771118cf3d1749889d8fe34caf"
    sha256 cellar: :any, arm64_sequoia: "47baaa05ef4f27c03d4bd8fd02ba23fca85c400d72edff36550a9d6642949e6a"
    sha256 cellar: :any, arm64_sonoma:  "04b85ecc66f6efacab14fcfe58378b338437635f5d099b0b783c12eda6bab3e8"
    sha256 cellar: :any, arm64_linux:   "6a079f1028886d60080d0c7bd8ac7b85493d813055db41913eb86ea35f90ddfa"
    sha256 cellar: :any, x86_64_linux:  "d1a97bad2ecd02a881ab89f20b356509b6fa518598f269a31785e9de9552da37"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  def install
    rm_r("deps")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBoost_USE_STATIC_LIBS=OFF",
                    "-DSTRICT_Z3_VERSION=OFF",
                    "-DTESTS=OFF",
                    "-DIGNORE_VENDORED_DEPENDENCIES=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.sol").write <<~SOLIDITY
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    SOLIDITY

    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end