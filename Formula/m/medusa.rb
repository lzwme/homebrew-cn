class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https:github.comcryticmedusa"
  url "https:github.comcryticmedusaarchiverefstagsv0.1.5.tar.gz"
  sha256 "fd5b2f3a9dd4aad51397b892a695d644809f15194b200d0e4221d1a99f43f4f6"
  license "AGPL-3.0-only"
  head "https:github.comcryticmedusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7da2c1a7788838fc892489be36ad27f2d8cb2564f4a2c50c74f82c301d3e78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36dc3fcb097a7352b0a72f54b657b74bd5777eb06c936068350d715c89650117"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab99ba1013332bb045b18dccd5d3bab3fb53c644106dce8bb5c2c2e1ab57dd01"
    sha256 cellar: :any_skip_relocation, sonoma:         "360bcfc531563c9a0865368f09ac9c049efab421eeaf15c99e1340c58431ccb5"
    sha256 cellar: :any_skip_relocation, ventura:        "e82619eaa049ad7d1521fc1ae85077dba87561627134b495131a3d22411aa0ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5b48d79d420b35432886deadf53bd635ce49d7df29c6230bd2fd084263df0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d4036fd354efc293b94fe230d4acfd3163eaa17df09759dad34db476dd80d48"
  end

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  conflicts_with "bash-completion", because: "both install `medusa` bash completion"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    (testpath"contractstest.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    EOS

    fuzz_output = shell_output("#{bin}medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(PASSED.*assert_true, fuzz_output)
    assert_match(FAILED.*assert_false, fuzz_output)
  end
end