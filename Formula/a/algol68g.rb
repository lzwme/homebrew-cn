class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.5.tar.gz"
  sha256 "ba58e6ad1d2c760e993c8cbbd75b09c9d80a96c87875375b36e0dc6ed7b3461a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bb228f929a2c7a101de4c6b2870a06db59de98be878becedd53e669292048d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f032276eb425df634de0c175922fb3286bba585642500b94f509948af0d66b97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e00aefd1898fbf8a53e2ebe760c595a51f2aebb4bc6a52d3684551bcc096810"
    sha256                               ventura:        "9a33a3bec37d13718054d02d89c05602afec212ba968825fe9d32783b0f1b071"
    sha256                               monterey:       "c7f5e8b617f9ba6b6bab1d29d0d43621d13bf5fafe7553de9c0cd33dfbe8e9f1"
    sha256                               big_sur:        "8f8f0f4a8cd5df4abde032eb3762666db7cb12c485cc247d9c676abd3d393d27"
    sha256                               x86_64_linux:   "a0950b820f228b30579324d46005567f28e06947484a0455a7d9cb8f7d4e96a1"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end