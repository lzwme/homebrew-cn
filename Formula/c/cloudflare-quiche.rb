class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.5",
      revision: "5ea8d8e3569c1ed34b895e2211e62791e77c29ab"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0daf578489fffa06860cb23c576190378d9ef6b81163dabcf1e7d42a73f72de5"
    sha256 cellar: :any,                 arm64_sonoma:  "7f33e9bea973e387451b04ef580937937be0756e2dbc0667cd817d8a03df4212"
    sha256 cellar: :any,                 arm64_ventura: "2752107cad370208caef6689b202b83da89f62cd8d39847788446d600a67e0c9"
    sha256 cellar: :any,                 sonoma:        "ec8f04c0f6836cdf348a13a56fb1e1a8376126d7c8b47572357741501e80fd98"
    sha256 cellar: :any,                 ventura:       "6d4d086140d7d0f1088116653f92fdde2d413839a573380c960893d1342d0f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6d5005f5afda9d3fd58f6430dc602e1b03b52a5f824005921562606adcebbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2554b4b477d78ef474d4a011d6ba37cce2ff84549e7158ca4f7d64fd602f9d0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

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