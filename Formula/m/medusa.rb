class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https:github.comcryticmedusa"
  url "https:github.comcryticmedusaarchiverefstagsv1.0.0.tar.gz"
  sha256 "edf1c8bd39051c482447da43ae86273014cf98c575eaf037bd0df908913a4601"
  license "AGPL-3.0-only"
  head "https:github.comcryticmedusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58969bef5f23f59e755668816dbbc96fa201037e3e8a52b0967887d0f2c45d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce9e36a96a38163c998c528c8d928396e4a242a2204f18ad3ec3d6b096803685"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70baf77a9e6ffc52a7d63dadbc1a9f632c3dd199aa74899e15901a492d61a20b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a01e3d399f3e471b6cdf2fbb03cce3446099943fb90d8d42e447a2861bce7aa9"
    sha256 cellar: :any_skip_relocation, ventura:       "a1439e024fbc878bc137cf8a4e7847966873d95230f82e0550df32e0ddf2861a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720cefb12dcf99d87345e5b43b4a0922b9610faf9be885998f47b4f0f80fc132"
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

    (testpath"contractstest.sol").write <<~SOLIDITY
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

    fuzz_output = shell_output("#{bin}medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(PASSED.*assert_true, fuzz_output)
    assert_match(FAILED.*assert_false, fuzz_output)
  end
end