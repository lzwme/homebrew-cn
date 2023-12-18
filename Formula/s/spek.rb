class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https:www.spek.cc"
  url "https:github.comalexkayspekreleasesdownloadv0.8.5spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b55f16cc8d72cbe070280e7a2ae5a3a3f2835cd16a9164263aee7e42725b27a"
    sha256 cellar: :any,                 arm64_ventura:  "39176b97ea98a6edb88925e271320df91b0f57dc3b2f2293fe36b2638d140d9a"
    sha256 cellar: :any,                 arm64_monterey: "952d652ec58560d90f9fee28bf09013eb9e2d4eea9466deb9eaa2263e6e6ede5"
    sha256 cellar: :any,                 arm64_big_sur:  "1a189684ff30213183297bc59a0abce362c535a4ce2c24be30ac9867c83a5b6c"
    sha256 cellar: :any,                 sonoma:         "893f1dc32aafec81c51387b78eddf1a56c8eda84b1a4a6464518de9109d3a59a"
    sha256 cellar: :any,                 ventura:        "c49d3ca280606b9383b2241308ee6c481a0357c98287df2597425b3f19d4f5d1"
    sha256 cellar: :any,                 monterey:       "da428a679cd0ee4e0f8c9bf2fcaf58e7a0197ab4889950f30627d7739442745b"
    sha256 cellar: :any,                 big_sur:        "631d9448dd6c9e5bcc6c8115156690ebc5040e25168020a07b187e7ebbf98605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1121d4f3e8c45223903db81de0d9c42258d7d4e44cc122a0a7d19dced845acb"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  def install
    args = std_configure_args - ["--disable-debug"]
    system ".configure", *args, "--disable-silent-rules"
    system "make"

    # https:github.comalexkayspekissues235
    cp "dataspek.desktop.in", "dataspek.desktop" if OS.linux?

    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Spek version #{version}", shell_output("#{bin}spek --version")
  end
end