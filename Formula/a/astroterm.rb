class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://ghfast.top/https://github.com/da-luce/astroterm/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5a5ba9564afb580fb493498b07b7b8eac8f7cdde3b83b180e62e85e4f7a6d6c5"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f32b203bd70212a9b5de3493151c3880583f635196e175ffaa049d038316488"
    sha256 cellar: :any,                 arm64_sequoia: "41a81c37e7970c0c57ddd819ee8753cd07b6c58fd640fa002002e4e37518acba"
    sha256 cellar: :any,                 arm64_sonoma:  "61c270ed295bbe8158713edac548a7359c7982560e03e2da6e94d4b6222a9047"
    sha256 cellar: :any,                 sonoma:        "ddcba4f1ad8451c726e6a5873ce29cdf7ec914249837883c7be462a244ae31a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10573ed3bc6370f188665a98781d506aa1ace3693a2bbd173e3ce543111c39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701d967cfa61fd068aa33c10f9bbb7b3558563f3d8aebba590b919aa585eab8f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "https://distfiles.alpinelinux.org/distfiles/edge/astroterm-bsc5-20231007", using: :nounzip
    mirror "http://tdc-www.harvard.edu/catalogs/BSC5"
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    # `mirror` has a different filename, but Homebrew always uses the primary URL's filename
    resource("bsc5").stage do
      (buildpath/"data").install "astroterm-bsc5-20231007" => "bsc5"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/astroterm --version")
  end
end