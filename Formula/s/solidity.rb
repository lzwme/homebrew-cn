class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://ghproxy.com/https://github.com/ethereum/solidity/releases/download/v0.8.23/solidity_0.8.23.tar.gz"
  sha256 "cce2c489ba0e29a5c37cc58bd3b3621d996658ffc78c6be8e75f744698068239"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf41ebaf0239c267516e61cacb2f448c4e6ce92e31bd6113ec1c8cda6200a17f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11a03dcae36a7f39e2e132bba0551a0664c9ff60bfa452c8afc0c6e8056d4a71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c289ebd7e11c62cd34156a8252c58c8f505d850ae9f38a5bc7014e766bc9cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "87961638ce35dbd517111606c58cf766040f1ec54eb34454531a42ee00fb3f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "bfcbc97ddd6cf739b2ab3eceac154f98b5596898e39e1caf19b750b330924249"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7115c22b33cc4d077f1dc87433529fe582dfa894eb5e8a4a10c406b7d612e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52bc28a4c457f84ad5e07a8a7c759f41e2718cd49102e983c68aec210804e29f"
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