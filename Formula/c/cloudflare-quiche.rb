class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.9",
      revision: "bbfe6205b8af2e6fadbb6d7818de463fbe123342"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ca6ad968cf8b1598652acb61a85711cd0249389208a751a7165a2dcce617cf3"
    sha256 cellar: :any,                 arm64_sequoia: "4b0fa50c30a37ec0340136a0914560f1e30ba91ef009552046bad8d1267cc515"
    sha256 cellar: :any,                 arm64_sonoma:  "784c2af35f2b10bc2b3599ff81d15e0bc8a2900f9a74bdae68d4f27145f0f655"
    sha256 cellar: :any,                 sonoma:        "33bc40c259994cccd1986794f9b099fe73da523c688f73d87e318bba3a4d2bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe0792f8226a038d830b55a80ade177f892c143e226a2af109923f699d37ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f087b8ea7a5dbbde76e3e961b2b85b28229e012b8d425f3384d3564fd2ce14f5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    full_versioned_dylib = shared_library("libquiche", version.major_minor_patch.to_s)
    lib.install "target/release/#{shared_library("libquiche")}" => full_versioned_dylib
    lib.install_symlink full_versioned_dylib => shared_library("libquiche")
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major.to_s)
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major_minor.to_s)

    # install pkgconfig file
    pc_path = "target/release/quiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(/includedir=.+/, "includedir=#{include}")
      s.gsub!(/libdir=.+/, "libdir=#{lib}")
    end
    (lib/"pkgconfig").install pc_path
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
    (testpath/"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end