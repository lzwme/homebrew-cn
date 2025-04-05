class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP3"
  homepage "https:docs.quic.techquiche"
  url "https:github.comcloudflarequiche.git",
      tag:      "0.23.6",
      revision: "42c8ea868b74df3cf4c6a533d15cb3bf3c3dbf79"
  license "BSD-2-Clause"
  head "https:github.comcloudflarequiche.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92221e6f19f49e1fcbf3ace60ef636738473d7d5c31637d5cd6a286eac43215e"
    sha256 cellar: :any,                 arm64_sonoma:  "f68fc0d0b41431e46da4446c1bb15dc9f299ab13831b4dacdb7ed568be2c7ac6"
    sha256 cellar: :any,                 arm64_ventura: "465b510aba699ad1cee1fbdc2431344d05ff4c98d7b6742a051af2ae4927e542"
    sha256 cellar: :any,                 sonoma:        "7fa65137f7a06266b1125fb26c5973d3af70bef4e865655fcb5ba355bd653e44"
    sha256 cellar: :any,                 ventura:       "d67e5fc1e1ae322e74d6630da2d3662f7ef5edd675f6248dcd95a0f01ed8fcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef2cc3c2fbc0b890472913bbba6f2e147bf11f3d40865a2aa5d468cf039251e"
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