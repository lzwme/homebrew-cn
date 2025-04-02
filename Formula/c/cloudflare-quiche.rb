class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP3"
  homepage "https:docs.quic.techquiche"
  url "https:github.comcloudflarequiche.git",
      tag:      "0.23.5",
      revision: "fde75a22236837680ca6108a7b25964aef39c846"
  license "BSD-2-Clause"
  head "https:github.comcloudflarequiche.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df14ddc39cd4ee275b1c8aad0bde2ee938a2b8fbf0de7414f30c9dcb35a5939e"
    sha256 cellar: :any,                 arm64_sonoma:  "f92255c2e089626872538163ec5dbe4fa923d0dad2db201333e95515d80c7820"
    sha256 cellar: :any,                 arm64_ventura: "2a26c0dc3086953c26e3787e68abee1945133351a06d4fa91b7ca02f9f06a0cb"
    sha256 cellar: :any,                 sonoma:        "76240ec5edb9873adc19049aaadc11796227aba59fd4d243018dcfa62d3ad918"
    sha256 cellar: :any,                 ventura:       "53a08b3171a0d9e05f9c2b1928a904a5b964ebc3ed8cc7d906b00e575b4839e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be77ed5b5ba6caad3e804817e15a4cbe53943674422d7c06ca3922a87c3e2e84"
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