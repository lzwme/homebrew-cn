class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https:soliditylang.org"
  url "https:github.comethereumsolidityreleasesdownloadv0.8.27solidity_0.8.27.tar.gz"
  sha256 "b015e05468f3da791c8b252eb201fa5cb1f62642d6285ed2a845b142f96fc8a6"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1af7a148cbfdd236f5006d50efe3ce949491fdecfc64299faf508c1db6e028fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ee562c269787f983946b0bd8ddad6752e5a66d1c0631e4be7632fed49b9484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "003ef65e343bde53baa391506860cee76d57df49561784c79ac4d185af59b11f"
    sha256 cellar: :any_skip_relocation, sonoma:         "780efbf9561fa353e7428750606700e886d2e1aade6de32dabf75c83356f6a81"
    sha256 cellar: :any_skip_relocation, ventura:        "13abc2146c369088cca72f183cd0037086f739ad08b9c7946cb12716faa69f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "7ddb6e0095672a2e6bcad1254eccc666fd6f156b4c66f9e7ef30c8436384dd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13dfa3f58fa921ba8ebb716ae0c12d8b343a66729b71847f7109495d8287bc20"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath"hello.sol").write <<~EOS
       SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS
    output = shell_output("#{bin}solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end