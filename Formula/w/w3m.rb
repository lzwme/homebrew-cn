class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  url "https://git.sr.ht/~rkta/w3m/archive/v0.5.6.tar.gz"
  sha256 "8dd652cd3f31817d68c7263c34eeffb50118c80be19e1159bf8cbf763037095e"
  license "w3m"
  head "https://git.sr.ht/~rkta/w3m", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "4d1b70b398bc3a41d00bac9aeb84e5b697cef48f4daf2da9b78440b45ebb64f0"
    sha256 arm64_sequoia: "b6e39e9e98c34c037f13b56bf6138a0df42b16f70607ee85b7e09ae0ecf6708e"
    sha256 arm64_sonoma:  "8dea1ca031a24f4e74a67d9b0887ce16567e235178ff9379a86aeef0b0ccdb3e"
    sha256 sonoma:        "ba058257e2b72d1f48947a0af5f4c6851e21c7bd8634dafc5f7482de4fbaa522"
    sha256 arm64_linux:   "669365ddf231bcd4acac703d1d2431a04253f8ba531dd9a49785e15eb5b723bf"
    sha256 x86_64_linux:  "02d2666c615eff0b1119e7ac2c85ae782ae0c06bf1c38efe21829cfd8a5941d1"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end