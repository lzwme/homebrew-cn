class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.37.tar.gz"
  sha256 "df15967d884e64f334a2a6102d7fc334afad1c96d6942c2923bc119f62a9e27e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b10b895937d66e2ab8f42257ec6689d8c451ac0e85079d9357923b1aa98a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc47667e7497373ae91569cdf9087dc3601d7cc5030f50961f1611dac00a91d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ad21943db8ba133d3bbc3047f315ce60eee13e836030cc4ca8e8e0ce9f81db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7622b3c39ce0a0c1b65dce24b5a7be83bebe1b4a6b951e6925d7516d295e6449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62d4cc7454aecd3eba07d9e479c09a3275c358b53a31541c1fe2b892dfcfd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2adbc9b0ffd56c9e9e8998efc6b5ef4a743c267fdc78dbe165b652d8177ee2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end