class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https:github.comcryticmedusa"
  url "https:github.comcryticmedusaarchiverefstagsv1.2.0.tar.gz"
  sha256 "41f285dd3e7676c69963674087055b33f27b985e07f9d4cd7645f0570bc05f76"
  license "AGPL-3.0-only"
  head "https:github.comcryticmedusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d29a3e4e6d710c32bb6acc3465e6489f06a899e21353aa812417011a16d7cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8ac155ebf9920f16bdda4350edfe7abe4cfbee1f281c3a275e46781d218e796"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95931ad8455fa6bef17d09b1f404af09600854b2dc26d1cc2eb5719719fd0ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "460ae45ac21c4356b0e6c4e4bdf9cde04fe044d29d6899be64f9d5144b4438ca"
    sha256 cellar: :any_skip_relocation, ventura:       "8ca81689f9f5b262d4b7563520125df33b63540716ae190a13f3f75f858d407c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dbda0f7ffd8cd4e4dc7a51771dd9e9886eb0fab0dc1dff29bfae8cec504f04e"
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