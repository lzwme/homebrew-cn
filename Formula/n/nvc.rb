class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.13.1nvc-1.13.1.tar.gz"
  sha256 "ad11c2594156aa3815cb44b68412f80800c8762523ab6bc7538834fa4106000a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "da06a9c56ddec6099b7ddce335937fad71636c1ba52ab1162b736bde6f615a71"
    sha256 arm64_ventura:  "519f481e48447fcac57a7d9002008f312f0083ac3bc4aaa1cddfa4407829493c"
    sha256 arm64_monterey: "cd60d857aa72d9a7ea3abb53759842b407e6705d6c055f925584553cb8cf194d"
    sha256 sonoma:         "f6cdd07299c758340f8b91fdef486ce81fcab7aeebd316cfdcb119a695faf6cd"
    sha256 ventura:        "5366f1c1441cd16bf840a28d8c453976dac61d42297bafa30c246b0355745431"
    sha256 monterey:       "30f25c370a9d156dcb75ad432eae39c6f1c315a544edc7b94d09783a0e138613"
    sha256 x86_64_linux:   "fa785942317627b19f92ac7a1e4164c3393d82fb7e96679fc86b0078ad45bfae"
  end

  head do
    url "https:github.comnickgnvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system ".autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "..configure", "--with-llvm=#{Formula["llvm"].opt_bin}llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_pathENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare"examples").install "testregresswait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https:raw.githubusercontent.comsuotovim-hdl-examplesfcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9bbasic_libraryvery_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin"nvc", "-a", testpath"very_common_pkg.vhd"
    system bin"nvc", "-a", pkgshare"exampleswait1.vhd", "-e", "wait1", "-r"
  end
end