class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP3"
  homepage "https:docs.quic.techquiche"
  url "https:github.comcloudflarequiche.git",
      tag:      "0.24.0",
      revision: "12d2af7dd19046eebfa8c14b409a31a0c38fbe48"
  license "BSD-2-Clause"
  head "https:github.comcloudflarequiche.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "058b6374aac137edef226eaf050a22fa52cc065e624a90ae5be971fc98de4fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "a8169b660496a9b4240431674500763194e3edda9b220a5a40b2da3df68c1703"
    sha256 cellar: :any,                 arm64_ventura: "d433bcf01b8f18987032ddb7ccc225eecc72a05e4bf3ab038798f9ed8c852867"
    sha256 cellar: :any,                 sonoma:        "4ee54eb622b0aec5dfac65b020bfc53cacba08efdbb9ef7b084e797d8694fcb2"
    sha256 cellar: :any,                 ventura:       "bf9e5d4d53333372bcab88c898cce6e0b7b3f48babe3ee9db90a4896c3df5b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccae091b6a4197e6f993c5ebf5f8ded5be2d8bed595613d91b230377d34d76c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8e3dbfdcc6a545dfbe278b05cd72bb1e0ef2e06f43005a8e4eb60e1804a603"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "-j", "1", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "targetreleaselibquiche.a"
    include.install "quicheincludequiche.h"

    # install dylib with version and symlink
    lib.install "targetrelease#{shared_library("libquiche")}"
    if OS.mac?
      mv "#{lib}libquiche.dylib", "#{lib}libquiche.#{version.major_minor_patch}.dylib"
      lib.install_symlink "#{lib}libquiche.#{version.major_minor_patch}.dylib" => "#{lib}libquiche.dylib"
    else
      mv "#{lib}libquiche.so", "#{lib}libquiche.so.#{version.major_minor_patch}"
      lib.install_symlink "#{lib}libquiche.so.#{version.major_minor_patch}" => "#{lib}libquiche.so.#{version.major}"
      lib.install_symlink "#{lib}libquiche.so.#{version.major_minor_patch}" => "#{lib}libquiche.so"
    end

    # install pkgconfig file
    pc_path = "targetreleasequiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(includedir=.+, "includedir=#{include}")
      s.gsub!(libdir=.+, "libdir=#{lib}")
    end
    (lib"pkgconfig").install pc_path
  end

  test do
    assert_match "it does support HTTP3!", shell_output("#{bin}quiche-client https:http3.is")
    (testpath"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system ".test"
  end
end