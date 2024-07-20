class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https:github.comcryticmedusa"
  url "https:github.comcryticmedusaarchiverefstagsv0.1.4.tar.gz"
  sha256 "7b101077a378b41b89c94571ff12425c5d37decc961b089910a5e5c4b89787ad"
  license "AGPL-3.0-only"
  head "https:github.comcryticmedusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ecf5a663e1f55e2a698b373648ff6aef7d324fe61b85f92494303a31d4ce43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c834112f76db15ef8f7f882da465474acc5df2afaece2fee910a9f0861cae853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325e1fcd741b3429e3fc37e3cd159139f2b8ea510b2beb15e493a6c57f9ba303"
    sha256 cellar: :any_skip_relocation, sonoma:         "324002128251f506226e3579bd1246649f4707b1a82c402c93f3e311ffceb91a"
    sha256 cellar: :any_skip_relocation, ventura:        "925ab3032f07dc086f8790b93648676fc8cdf573fae6bb1d246140e5f5850ce6"
    sha256 cellar: :any_skip_relocation, monterey:       "317be3bf7b4d274b612665bc70ca94e72cf64c50d0b0993dbdf1dd5188846e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b681bbd85ed5938d9b28b266b7091eccd912f0399afebaeb56e1f679918603"
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