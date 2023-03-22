class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/v0.4.0.tar.gz"
  sha256 "361d2e4150d5bf9a563face9113062335dab98f4c726ad58c4bc77252051e676"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e723f983900f7c2ddc08a81c919c3e393a8b560ec360a6715648523ce0f18c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ded012f5c7d389bf705cc71dcfa3954ce9852da2fd424b0b2e69121de72af3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bcf77384e51b8c74bc9ab95a9683b5a23ec81ee4387f40ab76711c0b4dd4101"
    sha256 cellar: :any_skip_relocation, ventura:        "88920e51ad292e367c1f943d1dbd8bdae96644243e4212788b6c76baea239856"
    sha256 cellar: :any_skip_relocation, monterey:       "a0228976176bbf16a58658a0dccc34394a486d86cb948a57d9bffbb94b2858db"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c7138504117ee877a0b9a1ee28581f9bdbf5ce4b43cdcc46afe63a655869f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7605f35f103352a5b22d1f4ef50118ca45e6c7b9004313dbc242144fa06a5cc6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end