class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https:soliditylang.org"
  url "https:github.comethereumsolidityreleasesdownloadv0.8.29solidity_0.8.29.tar.gz"
  sha256 "fe76237f513b7d6727a93cd5b83f92747650c8dc5f8f89457a41e8f54119ed38"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e2b446d615f9904d2404d7617bcbb5cd1a4649599bd2e6bb21660456a7c3d67"
    sha256 cellar: :any,                 arm64_sonoma:  "7e1748faeffb013047dc05b34b46d00fa40d7b4ee7fdefecde7cdfbb67853eb7"
    sha256 cellar: :any,                 arm64_ventura: "0aead765921ab4db364f04a1d2ad0a44e63f47df58ec025cb573462288c0273d"
    sha256 cellar: :any,                 sonoma:        "6f72f70d6f5ed6f143871f0031340c28356f08236320046db522989b1dd024a0"
    sha256 cellar: :any,                 ventura:       "a07fb17c1e38185be12b87b810cff01f7eca72af593967055c65ed8fced61538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a05ea5b761308854461ea6e7848a80ecc447919f46b3c916726d11d7eb615da"
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