class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://ghfast.top/https://github.com/crytic/medusa/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d38375a7f4c3ffaee40cb877142d7b824ea35300dd18a80ec9b6c706f7c584da"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5c25808d0a6a96efe1d2a317f4a31787cdb4ed612e39dbc85f9d89367dd52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f0084420762c26e96bf8a226336c619e298fc52b5b2438737de0cb07e97e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de59f97900df5ab33b120a32dcc1771ed3b5675f4595827afa638c1c0ff6bbdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "62217b5913b40cfcf357556828f8096bc968187548561399fe93cbb1afb7833d"
    sha256 cellar: :any_skip_relocation, ventura:       "0a316758d27293ad59ecba834097402315a127d8229fbc24d6ebc53e904e9eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b952ec6fffaa2a311405898955cb6d0927ed06acf470bed0a90b1f26eb1ab494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24c25fd9e1b978eea15f2861ba4312e1324cc36ebde14105084e65f75e5b40b"
  end

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  conflicts_with "bash-completion", because: "both install `medusa` bash completion"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    (testpath/"contracts/test.sol").write <<~SOLIDITY
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    SOLIDITY

    fuzz_output = shell_output("#{bin}/medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end