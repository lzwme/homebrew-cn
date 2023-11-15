class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/refs/tags/0.87.0.tar.gz"
  sha256 "9db8826bd0ea4930089b74622ae3eb9aea0e4ce1a45f481c806ebd48c3a9252d"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5afc81b7df2bc0751bd465ee840e6d554e1b519d3213b711f0f937916fbe5533"
    sha256 cellar: :any,                 arm64_ventura:  "c30d05dd34947f6cceccb15ecff0fe4a7ecbf87ae3ae5b12b1768a2d72729495"
    sha256 cellar: :any,                 arm64_monterey: "946585c5078fb62a22aae07020b03b6e41c9c34b93f680f12f03109cf741aaf8"
    sha256 cellar: :any,                 sonoma:         "9c961a399d764a5b27913cb421a36abdd8df3a4df6195135e8f26fdeeb4798f7"
    sha256 cellar: :any,                 ventura:        "23d44af3ea527848de168a915547eb641caf219a3d0d7da159fb0f3a64ee9525"
    sha256 cellar: :any,                 monterey:       "5a8640b9a25866e778aff011b9f824837e67f7a1c0db33cf8be50caf9a3ce488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eeb403cb20676d15efadade1c4be5ec1a206aeb0afd7c373363c3f54e169a84"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end