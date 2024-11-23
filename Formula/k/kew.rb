class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.0.1.tar.gz"
  sha256 "3b91d8cc661284b6f89ff54e59493fd3cf76f6e71f1d182c14b55a695ac47839"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc82a5f03eb1af8e658dd822760e908c47402a47df2dc3fa62b1468e0a1009bf"
    sha256 cellar: :any,                 arm64_sonoma:  "747bd2598cb4984c3992c67f08e5fc0014d1e164544da3b66068cc74aee10ceb"
    sha256 cellar: :any,                 arm64_ventura: "9151b839c74444c6a7785f90fb4fdbc8a6ad4d7aa897933d679292d48b4f88a9"
    sha256 cellar: :any,                 sonoma:        "43306e3dd89b7379cc295415d5c36d399ce222437c7aa9816737a6cf2b19821f"
    sha256 cellar: :any,                 ventura:       "ab89f48bc982c1977e699d15818df55da28618daa46318f5e3240331d41b12c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741cd3be83e16e34207727fe50794d50508417eadf8f87475c1b6e19f49e3518"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docskew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath".config"

    (testpath".configkew").mkpath
    (testpath".configkewkewrc").write ""

    system bin"kew", "path", testpath

    output = shell_output("#{bin}kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}kew --version")
  end
end