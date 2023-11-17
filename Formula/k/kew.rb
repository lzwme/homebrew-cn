class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghproxy.com/https://github.com/ravachol/kew/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "f63394302a45b3a36d1830e75339c05f0f947a31ab254ae426ee42a0fce66d7f"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9f568e43a63fc3dd2d0fc95d9f40fb2ef0a8f4aa503b25b118482372cee72b77"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on :linux

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