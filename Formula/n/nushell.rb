class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.108.0.tar.gz"
  sha256 "5995c211411ad1d5dd7da904b9db238a543958675b9e45f5e84fbdf217499eee"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26e0259f39ccfeadca54bc3ed50b108f610f47fe273f0729d2c3b45b21343041"
    sha256 cellar: :any,                 arm64_sequoia: "7e5b1363bb204f855f295ea9ba8c93d3137cc4e61f61487385a7f8f359543fdf"
    sha256 cellar: :any,                 arm64_sonoma:  "a8d58b9529805d0cb4f887656becc640c2ceb4110e73db269dfba67cc2ccbbe0"
    sha256 cellar: :any,                 sonoma:        "42c98bc06e8ec7ceff9c7238e2b2deceaf194c87dabc7f1ac17a727a8742042b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38759d54fea36a6ea03b9bd435f70a3804fdbdcba79bbc9d5cbefc7faeea118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a9886d3cfc00e5c7547a13bb342def2701fcf9c3e1949f2ebafed1491a55fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

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