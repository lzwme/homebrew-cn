class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://ghfast.top/https://github.com/okbob/pspg/archive/refs/tags/5.8.15.tar.gz"
  sha256 "c5aebbc16c35d6386fe9f5d8ab34c31c4a7b859017adb1a856aa2cacaec5cafc"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10b7661dcf750dc647ee20917d2935a54201e0ac962bbb43d7f31e6887ef3195"
    sha256 cellar: :any,                 arm64_sequoia: "c18f95c1972302027d0ef606e1bac60b071d77a5d5d4fa9bb9f9ffa97332939a"
    sha256 cellar: :any,                 arm64_sonoma:  "05b20b88553f81e2ee524dac5948ed73b40f3d2f3512af6d0af2f993aa9e2d73"
    sha256 cellar: :any,                 sonoma:        "4cbfe4e187ba454cdbc55566dc3292178b9a3a0dcec37dc448f6c92b6bd8302c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c4e1d79e3a3b1d57c895684685da899554db1a6493c9a4eeee8efe1890d8097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5383f3e886cf5c2baa4a81e65e2c588810e44d3feaee6d3dd3a980385ef1d8"
  end

  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end