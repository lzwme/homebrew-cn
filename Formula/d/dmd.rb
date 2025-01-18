class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https:dlang.org"
  license "BSL-1.0"

  stable do
    url "https:github.comdlangdmdarchiverefstagsv2.109.1.tar.gz"
    sha256 "8c2ce18945e3807a1568f6ec6ce0a8f2b88efa472ce0397ea1305fc2a1b8a587"

    resource "phobos" do
      url "https:github.comdlangphobosarchiverefstagsv2.109.1.tar.gz"
      sha256 "28974debe14d18eb58591db0dad3ddd4139e8f34783c3648c86619b67d7ba6f2"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 sonoma:       "888f4825c9f75197c67767be536fcd13c45c6d62758f3d0b6a5d05dd331f4d7e"
    sha256 ventura:      "dfdf2fc9e10f21f0dc248fbc22e66013e858738dfba0dc49f58b542b2dcba223"
    sha256 monterey:     "45b25904b2bb4003cb3f52ff6e375852f2eb753ed20d1061c3650fa825a9f74d"
    sha256 x86_64_linux: "cfb158ce63420e195494d3e2b211ca1d3c8c918850ea82cc7a3f8996c8b29dfb"
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
    odie "phobos resource needs to be updated" if build.stable? && version != resource("phobos").version

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
    system bin"dmd", "-fPIC", pkgshare"sampleshello.d"
    system ".hello"
  end
end