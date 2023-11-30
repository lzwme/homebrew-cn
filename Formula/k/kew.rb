class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghproxy.com/https://github.com/ravachol/kew/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "608a8720306207debf354558e547fc3b8e42f91b6e81c899bf7499ab5d3ef3d7"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "068d1c72cb845da4db93d166641d51185019fbe0343acaf5731538169aa50f29"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on :linux
  depends_on "opusfile"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    man1.install "docs/kew.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kew --version")

    output = shell_output("#{bin}/kew song")
    assert_match "Music not found", output
  end
end