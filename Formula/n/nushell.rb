class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.106.0.tar.gz"
  sha256 "3b0f26b293e76b4d6a9f593184ceca18e9853c6c5e81fcc958405040f0792bcc"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2db25fd2b430c228327801e79f80c4857039657f0fac2002a3ca33bd02d82ad"
    sha256 cellar: :any,                 arm64_sonoma:  "8166956c2ac17a5ae864ba438d21bcd69c555a85b346592083a484a5b4f261c3"
    sha256 cellar: :any,                 arm64_ventura: "ae0c3f2e01817f482f9c6e2691fe830a75d507be49f1cb85269cac666dcfd630"
    sha256 cellar: :any,                 sonoma:        "6db20b258891c4c82abddf0bc177304ee71e19e1b61e9d3e131bd4b63932f543"
    sha256 cellar: :any,                 ventura:       "3a61b8614a865e26050916ed7f835d4f02d0c5304e9bf25aecc30f7ef2da220a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27825879e997a463b2de24f9782990dd08c7ecd13fa4a73871641fabc0a0113c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94fb163ad7ce0fa18b714173fbe3341be350ce807d67d56b7c1f71c1908f231a"
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