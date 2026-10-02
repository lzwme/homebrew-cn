class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://ghfast.top/https://github.com/NixOS/patchelf/releases/download/0.19.2/patchelf-0.19.2.tar.bz2"
  sha256 "d4ad9a4e5c689e09119ce2f30a94b0e8b4f98c78590123ea21665e34c6928801"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd8031ce10d3b4494815b89f92d84f35cafe06629010d60407025fbb126f4267"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca983b871e31aa5ad8e5310f8436c9eea5044dce44cd6a9f2692dfcc8439bccf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "173b1c00c78d2626621a598ee0d79094dbee6e67c4b8636afef77098f4d13f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b902a6c4df239292e0bd32f17927f8500b25e4dbfd300ccbfb3a9da8efb91aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a42d6647f56285333fa8b209faf526eb85e409b3a818f5a99cf036e3367e3ab1"
  end

  head do
    url "https://github.com/NixOS/patchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp test_fixtures("elf/hello"), testpath
    assert_equal "/lib64/ld-linux-x86-64.so.2\n", shell_output("#{bin}/patchelf --print-interpreter hello")
    assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed hello")
    assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath hello")
    assert_empty shell_output("#{bin}/patchelf --set-rpath /usr/local/lib hello")
    assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath hello")
  end
end