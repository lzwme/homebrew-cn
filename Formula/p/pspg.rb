class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://ghfast.top/https://github.com/okbob/pspg/archive/refs/tags/5.8.13.tar.gz"
  sha256 "b6f198a98c0e8ec0f1ea0893deb23f20be7196a4f075c879722f91bef65a12f8"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4180db59b45def097f43d22fd83e449b068fc7a3a76ef69fc87f0aa918653c3"
    sha256 cellar: :any,                 arm64_sequoia: "3436cd3583592d1c2c960591799bd7b20042bcc734960ca3891b3f0d868e891f"
    sha256 cellar: :any,                 arm64_sonoma:  "82ca9ba3574553c336758be061f9ab6e9d43c99ec9826e830fea66ffa278f820"
    sha256 cellar: :any,                 sonoma:        "14b272a2466c38475f6627ede732299aabdbf4fa58ee593a525e28a264fcbccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc726276416c6bd323a421e4e94222926a8f9277f57f5fbb8a9f4ead1e639ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d0fcba5e33b6a5c1040c5c623d61985f61d5439b893c6a532ec6b43ddce0b5"
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