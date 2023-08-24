class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.4.tar.gz"
  sha256 "219e7307a9d7086070be1c7d092b96837906e80e9ffeea0a00e437d23be808a6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "823286ff9a1acef6521de84f30c7f0cc1483e001e9183547fe6df98d28d8d3c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96379eb5a73b3959c37f30d79bfad69ab90b1402ecbe6eb0f7fa405cdbd2bb62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c757727d6e16320bfdf4ad27dd54802e6bcc5ad10b71897bf38d7fe71dd47f9c"
    sha256                               ventura:        "3bba6a72d999230a00346800a5d294a1948629d8915002221d56fe23447504a9"
    sha256                               monterey:       "08c94bce1e328c93b34fad7d29d4a0bd67d5219f269cc3e65fc33f6dd9a3bf9d"
    sha256                               big_sur:        "af09289108d0129759e99eebf566fdeb96307e8de2d3c8657d48a096e7da3c22"
    sha256                               x86_64_linux:   "3dc8c3f55675caa047bd69428e6a9ab79985a6180e96e55a592dcdc591c843d9"
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