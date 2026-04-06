class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://ghfast.top/https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "795d0ac7f241d22930456eeff9a75e142cef150b7bf3365fb57b298c6557ef0a"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73201c47450ccdcbdc9688ca2262b95bed40d0bf62162918e7312cc3f9f05fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fbd80a4ee25c445639cd905f15dca80c2b4866681ab2f09ecae94ff7e4c68c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc3a5edf81a515828ef54964fa3fceb9903d294a8b5b5b1f27c20dce95c8e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eaeebb35aeeff85b903cdde3adde3254758cfb028e897285d4b51d72019047a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd91ab6e890554de7ebeeb7ac1fdc4a2c60518ae4423f87c0da04be972bfef1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a604df6d3a01024605b844875e72dbeb5e5525e6db2a211d5f8949079e46afe"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    # Create a 5 second test MP4 (same as ffmpeg test) as the test fixture is too minimal
    system Formula["ffmpeg"].bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", "test.mp4"

    system bin/"ab-av1", "auto-encode", "-i", "test.mp4", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end