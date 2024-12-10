class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.06.tar.gz"
  sha256 "abc70bfbfac0aac828a40cc0cc00d9caeef13bdc83a20b6747af4b1c128c8400"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?ratfor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82cdd7c6c5ce20bc8cca3833fbb17efbe5cc11196bf38890dfe4e8f2d4963168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c0139987632a9128be753dd456b5c09570966b450938aa2b62dbec90cebadf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88b136bf75ec71cf2fab5ca70b409c18bc167e90a68eeb1185f6cca67ce7d6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b63aafe4720050968a7a7adddedd050a4a7d4e2dd2cab286cf7814c8a3896f"
    sha256 cellar: :any_skip_relocation, ventura:       "c5914f56fb58e981dffde9e07c6cf1e9b57184e1ed2b9f289e0e5135053f176c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e74e886284b214c0ab05ebaa511b9ea25403b41a30e4f372db82eb9edc5a2f8"
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.r").write <<~EOS
      integer x,y
      x=1; y=2
      if(x == y)
              write(6,600)
      else if(x > y)
              write(6,601)
      else
              write(6,602)
      x=1
      while(x < 10){
        if(y != 2) break
        if(y != 2) next
        write(6,603)x
        x=x+1
        }
      repeat
        x=x-1
      until(x == 0)
      for(x=0; x < 10; x=x+1)
              write(6,604)x
      600 format('Wrong, x != y')
      601 format('Also wrong, x < y')
      602 format('Ok!')
      603 format('x = ',i2)
      604 format('x = ',i2)
      end
    EOS

    system bin/"ratfor", "-o", "test.f", testpath/"test.r"
    system "gfortran", "test.f", "-o", "test"
    system "./test"
  end
end