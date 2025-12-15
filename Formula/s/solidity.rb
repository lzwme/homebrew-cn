class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://ghfast.top/https://github.com/argotorg/solidity/releases/download/v0.8.31/solidity_0.8.31.tar.gz"
  sha256 "1efcf5af92e39499ce64d9cb33ba1cc1aa43d0aba107472915d732bf4a31c837"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1afb90753edef255f78a921de1268e70dc333725e72701775329c0e6b012e69"
    sha256 cellar: :any,                 arm64_sequoia: "b8523721b303160577d4f968ead04ce7dbee638e61b8c126dd557581f59e2f16"
    sha256 cellar: :any,                 arm64_sonoma:  "caf311ba3d956af223f4b74377a48a16d077feedbbf09e36f24068820c3a9f11"
    sha256 cellar: :any,                 sonoma:        "6d138907b4657d9dc29963ef55710bf71ff8c793fb8a7f559b2fbc6d1376a31d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96041ff2eb826145514555fa1314f8b31e8b1a36dc56e7f79a6ff94997510027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44dfde584a0d12ce6c928694a058019daeabcec1dfb485ddd1e13159ac1057eb"
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