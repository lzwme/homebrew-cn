class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://firefox-source-docs.mozilla.org/security/nss/index.html"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_98_RTM/src/nss-3.98.tar.gz"
  sha256 "f549cc33d35c0601674bfacf7c6ad683c187595eb4125b423238d3e9aa4209ce"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b790075f6dcb1f8494372bc44c0877021b3f89a1f5c3024d932be86a0d25e789"
    sha256 cellar: :any,                 arm64_ventura:  "bc927de4e93213be44a7aafe7449b13913a71b76efb415e9a481f8dd87bf2758"
    sha256 cellar: :any,                 arm64_monterey: "fc47979bce34e2b4679b3ca40b36fca4a2ed6a85ee0e530c11478f982c6c46d7"
    sha256 cellar: :any,                 sonoma:         "889300b0cb61c78585095533d48913b8d8053dc0c0c5da3c0ff3b1a0a389a69e"
    sha256 cellar: :any,                 ventura:        "b8b67373d240506768f0fd722759c2aff4cb6e355fd0d1e99047e5315d4a5b6d"
    sha256 cellar: :any,                 monterey:       "4b21f833949d2efc551ce57f9ab02a748ec98ffdb86c11efa7451a3ff6516877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1230eb2a5e3920995b77869ec39c9a04f7d16b7fef6503b6538103b581399933"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  conflicts_with "arabica", because: "both install `mangle` binaries"
  conflicts_with "resty", because: "both install `pp` binaries"

  def install
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_ALLOW_SSLKEYLOGFILE=1
      NSS_DISABLE_GTESTS=1
      NSS_USE_SYSTEM_SQLITE=1
      NSPR_INCLUDE_DIR=#{Formula["nspr"].opt_include}/nspr
      NSPR_LIB_DIR=#{Formula["nspr"].opt_lib}
      USE_64=1
    ]

    # Remove the broken (for anyone but Firefox) install_name
    inreplace "coreconf/Darwin.mk", "-install_name @executable_path", "-install_name #{lib}"
    inreplace "lib/freebl/config.mk", "@executable_path", lib

    system "make", "all", *args

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.
    cd "../dist"
    bin.mkpath
    os = OS.kernel_name
    Dir.glob("#{os}*/bin/*") do |file|
      cp file, bin unless file.include? ".dylib"
    end

    include_target = include + "nss"
    include_target.mkpath
    Dir.glob("public/{dbm,nss}/*") { |file| cp file, include_target }

    lib.mkpath
    libexec.mkpath
    Dir.glob("#{os}*/lib/*") do |file|
      if file.include? ".chk"
        cp file, libexec
      else
        cp file, lib
      end
    end
    # resolves conflict with openssl, see legacy-homebrew#28258
    rm lib/"libssl.a"

    (bin/"nss-config").write config_file
    (lib/"pkgconfig/nss.pc").write pc_file
  end

  test do
    # See: https://developer.mozilla.org/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
    (testpath/"passwd").write("It's a secret to everyone.")
    system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
    system "#{bin}/certutil", "-L", "-d", pwd
  end

  # A very minimal nss-config for configuring firefox etc. with this nss,
  # see https://bugzil.la/530672 for the progress of upstream inclusion.
  def config_file
    <<~EOS
      #!/bin/sh
      for opt; do :; done
      case "$opt" in
        --version) opt="--modversion";;
        --cflags|--libs) ;;
        *) exit 1;;
      esac
      pkg-config "$opt" nss
    EOS
  end

  def pc_file
    <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/nss

      Name: NSS
      Description: Mozilla Network Security Services
      Version: #{version}
      Requires: nspr >= 4.12
      Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
      Cflags: -I${includedir}
    EOS
  end
end