class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.7.tar.gz"
  sha256 "1494f2875b001ce36927a07eb7dad3f5df18b2fb417b969c129da84d172bed71"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "cf8f35e0b5018e5dab95936822aa8f5260edb47c7ca259ee59160b04af2eee93"
    sha256 arm64_sonoma:  "21edd3a96ae86281b62b2bb386af4fcc570616926329160b562e1ba4cd700407"
    sha256 arm64_ventura: "f09667c954528eda6ff7fb71bb0691102f87432deaea32bffeeeb0f07b71a3c7"
    sha256 sonoma:        "5b5e7ed65e2859fe2df1ff3729edd84e4228669a0efef06effa10576606ce586"
    sha256 ventura:       "e8162d9eda94ccdde347dc04a20e957263535188de3bcbc39e26fe323fd74b7b"
    sha256 x86_64_linux:  "8c2c5f0a93188796be7d5e5a8036eca69d2bd98eca875eb9527740ca0d970a4e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
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