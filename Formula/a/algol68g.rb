class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.16.tar.gz"
  sha256 "063d0cdd463e3b2165a7d082c932895e46d7047677bc884ead91093f76658db4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48963f8bf23cd568bacd762801f8311e0b0671edbc419686c8654dfcd464966c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a715f61be4375ab357f5263282d90e7be496ee751594bb1de1b36cc569bac3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33cc0c9bf86a4bac0d7673512bdcfef4766929b8198c3c1178e3d09d3fd0c587"
    sha256                               ventura:        "0b6e63200a6d9d93e688104c027cf71b6b16c2cb782982e6f2aa51cf8e794d58"
    sha256                               monterey:       "21adf5c8c556e82dee44a321a1fd83ee599bd1d29dff89c321a9971b67b6ae79"
    sha256                               big_sur:        "e088f3d5a7815404ea6946a95d7872f747c22ebe3c0e89d1f0be4982180cc967"
    sha256                               x86_64_linux:   "fbe5e37d0090cd7a8e783745132dc4bab2796d79341f8079df377420135b562b"
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