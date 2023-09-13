class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.19.tar.gz"
  sha256 "f4cc2da7f7f2cee8e03788147c6b96a8248d08a8d92f0c45a849f804e63b64df"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e95b67aca576eaf4a022ce478341d661800fc50a8b98f9150c575c90f2cf847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bfa3a3c69ad850c30319f1476ab3d75d63198f2f80f13bb9879b7343a98b09a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d101dddf6484fe6a53e690750191590e4b60c061122e28ab55602332c65bfa92"
    sha256                               ventura:        "634f1b70184f3aa6e01ef5894a6e53f385e9855bb21ab670b4d8443a6c818de0"
    sha256                               monterey:       "fcc04368784f191beaa3a8138169168b4b72f66bc1f659116d64cd71febca8c0"
    sha256                               big_sur:        "22e2d816475eb1052e47d12a12d9fdd615928f452267beffa0a8f79974556765"
    sha256                               x86_64_linux:   "1fbe8b5d77ca785d52c748ce3030c9ebe2039c2003a62f1bc5c685aa7ffb43fc"
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