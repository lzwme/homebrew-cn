class DoviConvert < Formula
  include Language::Python::Shebang

  desc "Dolby Vision Profile 7 to 8.1 MKV converter"
  homepage "https://github.com/cryptochrome/dovi_convert"
  url "https://ghfast.top/https://github.com/cryptochrome/dovi_convert/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "32b716f818e4f3d0f25f1bf7ff4a306cb6602858049caf0bbf36ce6056f1c5ab"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aeb7b7ca1c2635fa0ba995bcbf221105dc0306490935f73ef87d373ff11e7fb6"
  end

  depends_on "dovi_tool"
  depends_on "ffmpeg"
  depends_on "media-info"
  depends_on "mkvtoolnix"
  depends_on "python@3.14"

  def install
    rewrite_shebang detected_python_shebang, "dovi_convert.py"
    bin.install "dovi_convert.py" => "dovi_convert"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dovi_convert 2>&1")
    cp test_fixtures("test.mp4"), testpath/"test.mp4"
    system "ffmpeg", "-i", testpath/"test.mp4", "-c", "copy", testpath/"test.mkv"
    output = shell_output("#{bin}/dovi_convert convert #{testpath}/test.mkv 2>&1", 1)
    assert_match "Error: Input file is not a Dolby Vision Profile 7 file", output
  end
end