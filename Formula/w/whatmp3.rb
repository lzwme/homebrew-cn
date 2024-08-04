class Whatmp3 < Formula
  include Language::Python::Shebang

  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https:github.comRecursiveForestwhatmp3"
  url "https:github.comRecursiveForestwhatmp3archiverefstagsv3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  license "MIT"
  revision 5
  head "https:github.comRecursiveForestwhatmp3.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "8ed46e6584b275f429adc8ebd610b18b2c5990beaf03460025deed6cbb92efe4"
  end

  depends_on "flac"
  depends_on "lame"
  depends_on "mktorrent"
  depends_on "python@3.12"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    rewrite_shebang detected_python_shebang, bin"whatmp3"
  end

  test do
    (testpath"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system bin"whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath"V0test.mp3", :exist?
  end
end