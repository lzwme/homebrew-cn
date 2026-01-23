class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.33.tar.gz"
  sha256 "c545287de7284a644fe91c80917c0db5cd29cb4afa55edb84cc06a748d96107e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb2973dd2a21c78bd58fc373551cb50230e731ad26751a5816b19305cc2f9ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6aa7d3f5645ddf63f26b9f8bd64b76d7ca73f989d65502ff7aec8c2fab5a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db93074968e3e54033d1d26a0608f9494994d951eb8c053ac01e95ea36ca9e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "024a2ebcbc1f4937d14875f2cb8d12928a24a618fe30516894d530fd0caba396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a1ca2e42f537f9d6b44ae493ba711ad5a9a59a4f7fc2fece4b7623dbc412d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5257f69a2fa947ecaca566f4ea4021da0f0300f6a26d8ec4bf22b7557509d618"
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