class Twm < Formula
  desc "Tab Window Manager for X Window System"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/twm-1.0.13.tar.xz"
  sha256 "966c4df15757645943a916c1beee4ff4065b44fde00cf01f8477d8c1d0cba2b6"
  license "X11"

  bottle do
    sha256 arm64_sequoia: "c0175df9ff41d66725908d21ada7a5cc9dcd080402e22ab0d2b9ca4de03cb1ec"
    sha256 arm64_sonoma:  "3937baad8b912d38f6861142ea518b3526cf3dbe928d5f55b9a46290cae97de4"
    sha256 arm64_ventura: "9712d705fc554cc0134bcc06556f54344204d8487c4bcfedbd816f85e9bb684c"
    sha256 sonoma:        "d1d7019715c0dcfee9a7d52bcb6d5d144e61439b2aacf032a951547168431b08"
    sha256 ventura:       "cfb65ff9d07948b91b3bd1ae8777b91a3d4f16ebdd4eb581d97480ea424db73e"
    sha256 arm64_linux:   "9ab0aec7c88b5fc19c492f3564252b0acf691d8b15cfa556df068208683b4264"
    sha256 x86_64_linux:  "ba736d4e9cdf5dbc75f1b3f6ca39bf29851b41bdd7207d8d7294f1ee830dc404"
  end

  depends_on "pkgconf" => :build

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxrandr"
  depends_on "libxt"

  uses_from_macos "bison" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    fork do
      exec bin/"twm"
    end
  end
end