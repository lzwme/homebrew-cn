class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.5.tar.gz"
  sha256 "d83073d083b8339329a4abbf7f87b2f561250da92801580a14942603f2dd97eb"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcac670a2695fdaa26cb8c6b7970028556159e88ce4709bcef076a4b01fb5d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0974621894a70762ef36ce23a9dccde50855819036fdeb69392f389d6ffb9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf9f809d8d4544d9f48f8cc61b91c6ee823dc5857069534e6f8ae050369416d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b050fe4f5183110287103f0f5c36375c19432d4a504086bb7f8cf94f2a2125f8"
    sha256 cellar: :any_skip_relocation, ventura:       "ac2c56f94300b20f3ce009380e82814c4f55364edda14ca742d7cd569dcd09b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f457b29a0a1c01bfd318946d48c82832037a1b5d8d66b696a1950337dd2db0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end