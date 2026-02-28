class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.26.0",
      revision: "0ed0918d1b68965fe210ec32ae2a55a4f377766a"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d71b280f5a6d89f0e1558a972f793a6549d9cdb8c753ff007f58b4b5516679e"
    sha256 cellar: :any,                 arm64_sequoia: "33b791ee1e9605cec8c7d73d5995079c23a4fdfd459906d6684d2012295487f2"
    sha256 cellar: :any,                 arm64_sonoma:  "05bbea609d1a2b0acb453e946108b3770c808708a36be61f52abfc8f507e099c"
    sha256 cellar: :any,                 sonoma:        "5a20e8df5435aa55ff1549706af31ffa0fa1a56b27f40b48958219f6dd1422c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db33583caca0f0009eed5252e49e7e88df4d2fe2684d436c61cf37bff310d318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d0c492a08929940ee24b8eed3c536dcdd9c3aa88b287983e2c523ce2350104"
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
    assert_match "your browser used <strong>HTTP/3</strong>",
                 shell_output("#{bin}/quiche-client https://cloudflare-quic.com/")
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