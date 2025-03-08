class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https:dlang.org"
  license "BSL-1.0"

  stable do
    url "https:github.comdlangdmdarchiverefstagsv2.110.0.tar.gz"
    sha256 "e500b9fdf70fa1478dc5e2226588e840008ec4242076e7d171b87740e7c9f63c"

    resource "phobos" do
      url "https:github.comdlangphobosarchiverefstagsv2.110.0.tar.gz"
      sha256 "33a9538c829bd33751ec9bdae86d447f8ca59385fbf79cbb8ed7f59a4e7efc93"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 sonoma:       "ade2a77d54dd8a808e879bb7552da7ed330b8c8f7868e456ac6736cb135dc569"
    sha256 ventura:      "edcfd44651d0624737f59b353453c6355085f793c494dc70e9c5a6c11623e5ba"
    sha256 x86_64_linux: "15d54761bda5d0200ee8297405c42af4f43d3bf71bf7409731be50c6bc541eae"
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