class DoviConvert < Formula
  include Language::Python::Shebang

  desc "Dolby Vision Profile 7 to 8.1 MKV converter"
  homepage "https://github.com/cryptochrome/dovi_convert"
  url "https://ghfast.top/https://github.com/cryptochrome/dovi_convert/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "8830d07b076f2976d48c787315ae41294589a4846741fe202dc0c985788831cf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e422d75a9745c46a20ed71ad9ff5658cc2e1eea45ff66d7f4d9ec6fc14b86c9f"
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