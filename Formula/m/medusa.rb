class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https:github.comcryticmedusa"
  url "https:github.comcryticmedusaarchiverefstagsv1.1.1.tar.gz"
  sha256 "ea0056e40fe11ec5dd4256cf4bb61d4251af3b9c7f4a22a1a37d7539b642b1f3"
  license "AGPL-3.0-only"
  head "https:github.comcryticmedusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ccd57ac7c231429661f90e65c1f899e2f7a6521d24ac8ebae81fd81d06d06f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13dcf3f5cbfc86608589c781c761b563719fb8a4c7e1c8934b80aa60fd757be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b57eb723fdaab0698f66dfa2c4108cd080faf5f33ebcc738073f31699448bf96"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4ea2ef5bb5c39654b2944a3a4b8b15ecc9c3d6f525e128b6be0345e7c9fbc0"
    sha256 cellar: :any_skip_relocation, ventura:       "a326141d32b58a4a2ff86c62d290c697f5911b4941c7bd8008e3f8512f2abf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2d0c95431003d98e35636661868845758ff0b76ba96eef8627d37cc92c3d22"
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