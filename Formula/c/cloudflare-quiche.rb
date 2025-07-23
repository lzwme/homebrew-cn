class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.4",
      revision: "70d6d3e233568e906e66179a56c93cf9b0616899"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "397bcf2171437ad495e7d60194a5c19634a88cb83c1fa6d88124fb0264bcbbea"
    sha256 cellar: :any,                 arm64_sonoma:  "1b315676e4c54f8eec836bd1a012d48e6ac06f0224865866dcce0ccb7351ae62"
    sha256 cellar: :any,                 arm64_ventura: "ac3f4bfe0e8fcd607dc9586f4ed4d25799f706ccb76dd49121a72bad66652bdd"
    sha256 cellar: :any,                 sonoma:        "0ef6fecb109d989765142c1d0ef7c3c323a75620b53b48641558aacef32dc840"
    sha256 cellar: :any,                 ventura:       "05ae2be55deef5bcc242d3425f11e1e8c2c4147b1e1c567f6b31f6b36c1383e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7dae91cd8972dc46220d15aaff7c51926b08b182b5a16b0e193f738972ba10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1df02d761f38515ecb839c3a691c772f198917c10acac92db8ee2c06e7fde81"
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