class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.23.tar.gz"
  sha256 "3574889be565eff353f24b346cda960086256edcc6bf4ab4733c611a8945d5bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5a60fe6589d2e33656237e29b716ba857d6a60d2fdf68876f8f8701e2986566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b15ff8fbe891058db361d22e5e5af68e7e2e99dbb70f7b681fd33b3a01d1a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0c98ace618aa3fcd3e43a9341f7fe0e79bf321d565ddd86573388619149a47"
    sha256                               ventura:        "c3bdd1fd29ed5b0724a32ddb65480a6ffb54901751656db09f36ce6988a29385"
    sha256                               monterey:       "0f8f8c607ecdcf379190babe88723c72073b8d02c59a93926861506076749400"
    sha256                               big_sur:        "1b6fdefc51d2336c4d03e72f3f81ce283e759ff72953ea254206a96ec03735f7"
    sha256                               x86_64_linux:   "9f3e2ccd5fc19b76db75c2bb0d429cbf54bd401fc9edf3df5f3e5dfef2132162"
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