class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https:soliditylang.org"
  url "https:github.comethereumsolidityreleasesdownloadv0.8.28solidity_0.8.28.tar.gz"
  sha256 "ec756e30f26a5a38d028fd6f401ef0a7f5cfbf4a1ce71f76c2e3e1ffb8730672"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa6ea61e77891d4b07512a4f0d376a276a9e9da023fd35d61384cf7bec8881fd"
    sha256 cellar: :any,                 arm64_sonoma:  "c6cfc02eaf2b37f9599b0244b9264d9aef9a1e6f4f1ce7e240665e438de7ad9e"
    sha256 cellar: :any,                 arm64_ventura: "06585c25a8af2fab80b72ec8b5765406638322f3eb2b606854c92b8b1248e29f"
    sha256 cellar: :any,                 sonoma:        "0b31144825498cc45ad6e1032e73ab889f8b1ec60f337edf48b4e88598cceec2"
    sha256 cellar: :any,                 ventura:       "db923317dab7f9f285127343dc9b34e04232293f27871d2598c137dc5cfa5363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d87936e98edbed99275f8c30d847bd715edce12dab50dfd1aa7f4e023f24411"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  # build patch to use system fmt, nlohmann-json, and range-v3, upstream PR ref, https:github.comethereumsoliditypull15414
  patch do
    url "https:github.comethereumsoliditycommitaa47181eef8fa63a6b4f52bff2c05517c66297a2.patch?full_index=1"
    sha256 "b73e52a235087b184b8813a15a52c4b953046caa5200bf0aa60773ec4bb28300"
  end

  def install
    rm_r("deps")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBoost_USE_STATIC_LIBS=OFF",
                    "-DSTRICT_Z3_VERSION=OFF",
                    "-DTESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"hello.sol").write <<~SOLIDITY
       SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    SOLIDITY

    output = shell_output("#{bin}solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end