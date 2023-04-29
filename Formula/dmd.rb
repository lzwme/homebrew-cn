class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"
  revision 1

  stable do
    # make sure resources also use the same version
    url "https://ghproxy.com/https://github.com/dlang/dmd/archive/refs/tags/v2.103.0.tar.gz"
    sha256 "98d02ae197dc3ec7959343f6a61ec18294d4e57d61f7749287c6d56270c3891f"

    resource "phobos" do
      url "https://ghproxy.com/https://github.com/dlang/phobos/archive/refs/tags/v2.103.0.tar.gz"
      sha256 "65d0d5ff4bce2ea881fc5db5140ec14f7567e87d4dfcdb16f400e1e4457e9221"
    end

    # Fix build on Ventura when newer Xcode is used
    # Patch merged upstream (https://github.com/dlang/dmd/pull/15139), remove on next version bump
    patch do
      url "https://github.com/dlang/dmd/commit/deaf1b81986c57d31a1b1163301ca4d157505220.patch?full_index=1"
      sha256 "e16eb257c861a612b7fa3a8486e292b7f7faa0bd38a71e0c45d4afada790b7c3"
    end
  end

  bottle do
    sha256 ventura:      "43e0df0f5bccfd8098e2d9a5c824034373f7a8c3b377a9042547c01d79685c59"
    sha256 monterey:     "7190d5b87d93c66d08251bf92f1826e6b1005634b8155bf89ee77941b4a34718"
    sha256 big_sur:      "5a7eb0929b5bd41cd0a1a5e1b1a2b0f0ba44003000c2d24f3c69392b2f50c43d"
    sha256 x86_64_linux: "fcc6137d25baf01eb398b48d835d698e0234a91d5653ec49d54a6a7cecb6269a"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  def install
    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{Formula["ldc"].opt_bin/"ldmd2"}
      ENABLE_RELEASE=1
      VERBOSE=1
    ]

    system "ldc2", "compiler/src/build.d", "-of=compiler/src/build"
    system "./compiler/src/build", *dmd_make_args

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      DMD_DIR=#{buildpath}
      DRUNTIME_PATH=#{buildpath}/druntime
      PHOBOS_PATH=#{buildpath}/phobos
      -f posix.mak
    ]

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated/#{kernel_name}/release/64/dmd"
    pkgshare.install "compiler/samples"
    man.install Dir["compiler/docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
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
    system bin/"dmd", "-fPIC", pkgshare/"samples/hello.d"
    system "./hello"
  end
end