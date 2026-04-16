class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://ghfast.top/https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "95bdbd84198eb00cac090ecedad387eabcfb5815ced97467a24c518020cf48dd"
    sha256 arm64_sequoia: "8595dd94303e84f0d359fcdfcb507d1d5bf72254e73f10126b46b3bf1f04e13a"
    sha256 arm64_sonoma:  "7038fdbb6d201ee9b7ffe0b21e350783c42168d3651f0c8259a2023282c782f5"
    sha256 sonoma:        "237e81120aa836dac06a16342cad1eda81fd155ae731a683b2a819e27a43c2fb"
    sha256 arm64_linux:   "ea893dc5171591d4aec0142c384d8b91cbb0766d9bf0b194a9837cee7ae65f1a"
    sha256 x86_64_linux:  "f23aa8887c144680a5bf5429151d57a2cb8890cfd3e7989daf55ba631e565777"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    args = %w[
      --disable-silent-rules
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]
    if OS.mac?
      args << "--with-appletls"
      args << "--without-openssl"
    else
      args << "--without-appletls"
      args << "--with-openssl"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system bin/"aria2c", "https://brew.sh/"
    assert_path_exists testpath/"index.html", "Failed to create index.html!"
  end
end