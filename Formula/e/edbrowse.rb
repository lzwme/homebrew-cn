class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://ghfast.top/https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.14.tar.gz"
  sha256 "4463d4ad9d06f183ebca8dfee0eeb7f4240bc6becb83257e394fdeb84b120360"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a56226c0657151035fda0cfbf5f7fed4d50f7755984c046729fe44a95c4d1192"
    sha256 cellar: :any,                 arm64_sequoia: "cdc9419f5bc0ae97bf9f3956f84ad0b93012b3c0703ad229808589336222cd77"
    sha256 cellar: :any,                 arm64_sonoma:  "23c7fad4fd603423b83462eda3094d50c0b7bf1bd2f068cae21c3448e765a39f"
    sha256 cellar: :any,                 sonoma:        "2bd307611a82ddb6140ac6753d23faf19bd8f4c9a0104a03a2c34275ecba3a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c97fdc88bc3ef48aa1f56baec88725b968db6d449583d6c5878f3182bfa848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb9a220aad742e35326a2605af428e34bda827ef83999b99c3435ffc879a134"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
      ]

      system "make", *make_args
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/".ebrc").write("")
    (testpath/"test.txt").write("Hello from ed\n")

    system "printf %s\\\\n 's/ed/edbrowse/' 'w' 'q' | #{bin}/edbrowse -c .ebrc test.txt"
    assert_equal "Hello from edbrowse", (testpath/"test.txt").read.chomp
  end
end