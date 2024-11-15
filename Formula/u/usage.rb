class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.3.1.tar.gz"
  sha256 "80a88cd029a7b57d62486f64b49eaec5242100ed9831cbea82c6d6e392320317"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24653073729a86393e0e713c165af7ce5648863a88c907a18cc1d2932180a22c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0c30748302038b7868ef1b384b04073bc61f936d51e6acb7f4c0d39fbab3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f858286380f4cf8d0f5ae20896f9812e5913bb17200df5024c962a59afe9aca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6712920d2cd2478df3fc0c0469795012f33e1a0c6bd2b3a98d2e5ff87576f43"
    sha256 cellar: :any_skip_relocation, ventura:       "3f51103237f14871461f6ca2453672236858f7b8d1bfbafb9aea90ff6a6b2e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23d0cab4ce7ce80fed401fc6fa12fc38d7ef61771564fba4574895bbd7cd214"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end