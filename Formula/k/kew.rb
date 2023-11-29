class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghproxy.com/https://github.com/ravachol/kew/archive/refs/tags/v1.8.tar.gz"
  sha256 "5f7f9580011ce56bbd6c50e766542bee93965a9d6ec5998f3db28e989d1de056"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eed69af58ae7f2f1bd5205d1caa8c9b7db0deadc8bad0fdd6949d6d2b9a1e538"
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