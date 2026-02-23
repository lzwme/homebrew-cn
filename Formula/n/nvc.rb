class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://ghfast.top/https://github.com/nickg/nvc/releases/download/r1.19.2/nvc-1.19.2.tar.gz"
  sha256 "328ffbf4dea1fc2087eedd713ba92af2dfabed88bb6f8428635bfd12bb479674"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4ff41dc327ae109878df24148d5a7d6eedd45ad417acabb5b430ad766613cb70"
    sha256 arm64_sequoia: "d68dbe9133256f1674ae140d89a839709984f89cb68fdc3c6ced766e2ddeb9af"
    sha256 arm64_sonoma:  "8b72c0af468ad633ec65bbb4f5c84ecf4cd31b1d865475f596dab7efc9784f44"
    sha256 sonoma:        "3f40d4f7824a6ce19069c5b58fe6930ae123178849abdbae053cfe55dab0331e"
    sha256 arm64_linux:   "ee9aa4fcb5988b6a846462562934266290ed2187d41cc2e2466d804267ee782e"
    sha256 x86_64_linux:  "3fc7befa222792ed438216154dd41ee813596f98ecb49acdd92e73ffd9e2503a"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https://ghfast.top/https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end