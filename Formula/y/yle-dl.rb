class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/0a/b5/ec7799b29199420b8263526dba8cafe6a4a57de70086453291244b25596c/yle_dl-20231120.tar.gz"
  sha256 "35a0a077c32184ee993ef953ec9a74098399b3094009d562cc3638470d745218"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c61dd6b0dd672d7fc02b3d7df5e0f698ded4c1ecbfc421aa3e38ebcc1fb5d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff56b673a7d275af4261fded367559096287877bda0ccd81363099ba5b4b829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c216eeb806eb231391896d18b252c33a047371c5b24145f98811ed761e9c9b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b36567eb141e21083aca0b218826a88ad2e022b2ae204a9c8a24258583909b0"
    sha256 cellar: :any_skip_relocation, ventura:        "70421e0b3c18ad6f31e8e9a0c4559392c8301231981c1274af5b47b8c718cfb6"
    sha256 cellar: :any_skip_relocation, monterey:       "49bdbbd24fc53b732b73a7eb3d89262fab43521b3e2cae58c52a6a5dade80ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1df68998e32f60ec93a7f0b478645c92c137f92aa7bdf1b06c0414aafe012ee4"
  end

  depends_on "python-flit-core" => :build
  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-configargparse"
  depends_on "python-lxml"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end