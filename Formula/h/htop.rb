class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://ghfast.top/https://github.com/htop-dev/htop/releases/download/3.5.2/htop-3.5.2.tar.xz"
  sha256 "225128e697c4a8c8a878fd0078c965ff8bd5fb24913bfc8473b8edbd50f843f8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fcd2302f01490680101ec96b7338230e8e74c2061cea9139d8b50731ab44c874"
    sha256 cellar: :any, arm64_sequoia: "1571d6aa264fb71ec23282651d005d02ae2c58be25c77f54a177498ce4953814"
    sha256 cellar: :any, arm64_sonoma:  "6ea6d70385c51d699068066f2652d12d4b6166541ce6c3accb680c3a0627d399"
    sha256 cellar: :any, sonoma:        "8c6d5453410472b39b5ab5951e5fc3d0da789ba29f73aa785cd429626605fff9"
    sha256 cellar: :any, arm64_linux:   "8e6cf12deb2ff22ac67dcea4bffb61fee5e2c310fd941f906e317e45ebd6454a"
    sha256 cellar: :any, x86_64_linux:  "94b1fbc2ed2be30a24ff5c46e80cc0c8b164c176f0a38709b92443ddcf7549a4"
  end

  head do
    url "https://github.com/htop-dev/htop.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh" if build.head?
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output(bin/"htop", "q", 0)
  end
end