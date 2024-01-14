class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https:dlang.org"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https:github.comdlangdmdarchiverefstagsv2.106.1.tar.gz"
    sha256 "298e2933a4cf87933f73e8ced52c34f4be97e884a4cb6f95e31754e62ba10fcb"

    resource "phobos" do
      url "https:github.comdlangphobosarchiverefstagsv2.106.1.tar.gz"
      sha256 "acf2a27bb37f18aff300b5f38875c2af1dbb7203deddca7f870b3d69a791f333"
    end
  end

  bottle do
    sha256 sonoma:       "79bcc4e16a2b8178a6ec3e65026b5abebf3627dc0f1305e6d18825f74b37fa3c"
    sha256 ventura:      "75de6c1b2335fb1b74fea324ef5c087424166ae92629f9fbbe2cfcc541d770b1"
    sha256 monterey:     "58d95b96cc93d4b1c8107a07a06680b116df01078aea17842c5dc4b5e814e775"
    sha256 x86_64_linux: "ee8274cd9ab39504f0aed85df9fc40319d3e598981b40419c86d66e6b9313e5b"
  end

  head do
    url "https:github.comdlangdmd.git", branch: "master"

    resource "phobos" do
      url "https:github.comdlangphobos.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  def install
    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{Formula["ldc"].opt_bin"ldmd2"}
      ENABLE_RELEASE=1
      VERBOSE=1
    ]

    system "ldc2", "compilersrcbuild.d", "-of=compilersrcbuild"
    system ".compilersrcbuild", *dmd_make_args

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      DMD_DIR=#{buildpath}
      DRUNTIME_PATH=#{buildpath}druntime
      PHOBOS_PATH=#{buildpath}phobos
      -f posix.mak
    ]

    (buildpath"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}VERSION", *make_args

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated#{kernel_name}release64dmd"
    pkgshare.install "compilersamples"
    man.install Dir["compilerdocsman*"]

    (include"dlangdmd").install Dir["druntimeimport*"]
    cp_r ["phobosstd", "phobosetc"], include"dlangdmd"
    lib.install Dir["druntime**libdruntime.*", "phobos**libphobos2.*"]

    dflags = "-I#{opt_include}dlangdmd -L-L#{opt_lib}"
    # We include the -ld_classic linker argument in dmd.conf because it seems to need
    # changes upstream to support the newer linker:
    # https:forum.dlang.orgthreadjwmpdecwyazcrxphttoy@forum.dlang.org?page=1
    # https:github.comldc-developersldcissues4501
    #
    # Also, macOS can't run CLTXcode new enough to need this flag, so restrict to Ventura
    # and above.
    dflags << " -L-ld_classic" if OS.mac? && DevelopmentTools.clang_build_version >= 1500

    (buildpath"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=#{dflags}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  def caveats
    <<~EOS
      Ancillary tools (e.g. ddemangle, dustmite, rdmd) are now in the `dtools` formula.
    EOS
  end

  test do
    assert_equal version, resource("phobos").version, "`phobos` resource needs updating!" if build.stable?

    system bin"dmd", "-fPIC", pkgshare"sampleshello.d"
    system ".hello"
  end
end