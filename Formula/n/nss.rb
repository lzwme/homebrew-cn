class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://firefox-source-docs.mozilla.org/security/nss/index.html"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_119_1_RTM/src/nss-3_119_1.tar.gz"
  sha256 "1387b8478e6c681c533b1f7b0f4d4ef7f58307c1f7e3a353622ddbf841328283"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa198e16da7993c22d9271860c565e744ce9ef8d78177d70cd1a342db573656f"
    sha256 cellar: :any,                 arm64_sequoia: "e46f202f40ab041c9c331e7d5228f62e058a457b93b6572c5a96b05180ae1235"
    sha256 cellar: :any,                 arm64_sonoma:  "96b7afd9f9e31aaae7fe8024c2677b4e1752a903caea40cb140cb20cb4f2f120"
    sha256 cellar: :any,                 sonoma:        "07ce5a4f6d3194729b75f7db6bbeaea3975db2ec265667ae8d07e53aa1b96836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd80d95f8fe53bcb9db1d67953ff7c8f547bc4af26892ccf6a4dcc2a0ba0fb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4d851176940bdeedc488ba8f7c27727721ac39c208731140ae6269cdaf29c1"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  conflicts_with "arabica", because: "both install `mangle` binaries"
  conflicts_with "resty", because: "both install `pp` binaries"

  def install
    # Fails on arm64 macOS for some reason with:
    #   aes-armv8.c:14:2: error: "Compiler option is invalid"
    ENV.runtime_cpu_detection if OS.linux? || Hardware::CPU.intel?
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

    include_target = include/"nss"
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
    system bin/"certutil", "-N", "-d", pwd, "-f", "passwd"
    system bin/"certutil", "-L", "-d", pwd
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