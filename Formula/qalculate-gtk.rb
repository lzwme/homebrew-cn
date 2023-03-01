class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://ghproxy.com/https://github.com/Qalculate/qalculate-gtk/releases/download/v4.5.1/qalculate-gtk-4.5.1.tar.gz"
  sha256 "1f8b95cfb8267c60c8e1c2faf78f6fc487714d6d504b2a121809ca5582e2d656"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "48f1ac49fbe600a322149e84fbce166d19dea9d72f16535e44f6971eda6d8889"
    sha256 arm64_monterey: "ba397ccfcd9c9e389f430991b4b669c208cfbd4608b89740402ab954d5e5f6f2"
    sha256 arm64_big_sur:  "3d78ae38524d41f016efd7d3ac162a9ef894a3d380c340c2a6f199e5ae049373"
    sha256 ventura:        "cfa621f22a540c319ba80f3b703b3781d72caae988cb7027e94b94feae24a83c"
    sha256 monterey:       "1144ce5143d16d5ece1d966c84b729b83b747dcc37552e34c25dbeb7430dce4f"
    sha256 big_sur:        "f6bff062d3695d239c17286a7a065578056d5ff032b43057b502ce979de11abc"
    sha256 x86_64_linux:   "455c9601dec69bd46ea65aa25fbcb6294784efea2b010036f4d75fc5b60c51b3"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end