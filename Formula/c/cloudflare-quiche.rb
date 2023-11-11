class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.19.0",
      revision: "af368e9287ea975d184f9f66df52dbf109adf0e4"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "053fef23de7d106851a54c53f945f89807968479bb87547a5fa8cd857d7d56a9"
    sha256 cellar: :any,                 arm64_ventura:  "9c1c55a258ca0eff04c447d82d1b4c8ee924273ebc445aa14a4d335fce5fd533"
    sha256 cellar: :any,                 arm64_monterey: "023545e9d025d59b29295dcdaad06e6f0b01c803e9e98d721dd12e9c79c0573f"
    sha256 cellar: :any,                 sonoma:         "880bff4e132788f598b8722b8c30666b081b8a252bae7faf1d8454c1aa124d00"
    sha256 cellar: :any,                 ventura:        "48067808a1d32458d8340c6e961c01c0c50c70fa5dd147ae6e219fd46517b40d"
    sha256 cellar: :any,                 monterey:       "6c7a64ee008b75bef7668ed73aa8e893611eb5947751ccb83638fa0e2ea8c898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c91660ce7c61fc3f137204e4629201dd3ff5ef9d14d5e29c22c54836bc04814c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/#{shared_library("libquiche")}"
    include.install "quiche/include/quiche.h"

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
    (testpath/"test.c").write <<~EOS
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end