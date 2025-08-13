class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.7.tar.gz"
  sha256 "91079b549aafb82eefb0aad2708ab266364fcc6fd34eb8f339fc79180d704a12"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0505b79426e75f8040fc4ee1692c1ec33f6c1551181ab8534cbde144af156721"
    sha256 arm64_sonoma:  "8c1fa19e1d76d9126404bd80b93e7f7e2483942de29cf828e5c202017cae1d1a"
    sha256 arm64_ventura: "1f4d5e9a94306b51a6103b648e3edb5ff82ce05494c63dc177ee1019f9f144f6"
    sha256 sonoma:        "a7e83525c12fa44646e8892ed6fe9473527fd06e398af42ac3c81d07aee725f5"
    sha256 ventura:       "6c226251937932956b095b45b7c1663e35ef9502566ac9ff7a36648baf9f6439"
    sha256 arm64_linux:   "b58ebd8d18ae7ce19b67da0357d283aad72dcc0e4dad4748d2e0f366f622051f"
    sha256 x86_64_linux:  "3ad9ea701768f1dd9a08ec7cd33b19a36c78bdc4a18743a8e155fb79eaca81c5"
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