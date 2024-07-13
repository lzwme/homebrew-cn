class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.101.tar.gz"
  sha256 "25064182c731a0cbf80e48bbeecf2d628e2be41046f84aec0d89d8e7f6a6dcc0"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a58b0c45b9587c0cc312e02b729b838ee49f743a126d070e2d211bb0fda5c06a"
    sha256 arm64_ventura:  "61c398885d3e8c96160462a3e309782c140c848802bcbf605f49d331ce604dab"
    sha256 arm64_monterey: "29dccd4a4efa0a3117f6645f731e6586881b7c93b115fb0d7661fb3e856f71b1"
    sha256 sonoma:         "a02b4331e36399f3535134b3cef5f67a3f3735e65dbabded6229d7fa7833ff5c"
    sha256 ventura:        "37b7a21513219e26ff182d593e4f198a64952117be3e6a7fd636dd9a7d0c7eca"
    sha256 monterey:       "c877ab51ccbd712d8801fbcb0bcc8dc59155f5821e39577c720763e7a4d3d1b2"
    sha256 x86_64_linux:   "7092ddb235700573fcd2f88072d9cbe18f701630da96681f8094c098e27c542e"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libressl"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@\d+(\.\d+)?}, Formula["libressl"].opt_prefix
    system "./configure", "--disable-silent-rules",
                          "--with-libtls=#{Formula["libressl"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end