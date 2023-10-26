class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://ghproxy.com/https://github.com/ethereum/solidity/releases/download/v0.8.22/solidity_0.8.22.tar.gz"
  sha256 "f4beee1ec28abcf5e844c93b0f2b46133437eb0736024a9b6b0742a6078c0726"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d233da0a2c56188bf6808fba5046183e1a5887dc6db51488bda798caa2f2b9a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "523265adfec9b24050d3b6e2240e51fc43d5098798106a5574f8f684bd1c46f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad524465e81ab0b843dbcc0a626aa377f265ce4913bd80ca002bb3c99d18248"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae788f35a9d52064fa3aead0eb0a567bee0cdb8bed719c2e26c2c650c9867231"
    sha256 cellar: :any_skip_relocation, ventura:        "3eccf79a4bb6bf0b5d7d4e287b0875455cbf316275b4bb35f4cf2eb3dfaf80b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae810bbba3979e2d380b2132baa384c2aee79a0c9c59afc8ff490f1a5687046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449fbaf8c7362b46874a0f0653d092b00b7b502cd89c816f43d7d735ce406c98"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS
    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end