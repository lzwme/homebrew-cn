class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https:github.commozillasccache"
  url "https:github.commozillasccachearchiverefstagsv0.7.6.tar.gz"
  sha256 "c6ff8750516fe982c9e9c20fb80d27c41481a22bf9a5a2346cff05724110bd42"
  license "Apache-2.0"
  head "https:github.commozillasccache.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eedd3f0f33fd76c4e0dfecb4bc4a5c8166852167fedba8a3b58d29e36e0f745e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2002c5e9d6be9944324a3f483f0f54b4bceb18daf57084c1708683bc5648e850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466aa9717f01b5ff0b089b419905f0e8cb8dd236c3592f609cac331c985f6ff2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2983ceb7542667fb8fd34b91a0b29d7626c912f027fa122a2f53863710ebb854"
    sha256 cellar: :any_skip_relocation, ventura:        "b93f63c71b8f0b89bbe364f7824b20fc159ead0fac6ba889af5cc51882235ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "708e197f5609513e8f92daed4d219df6538d9f7b04fe7a1a7eb79bf7e4ab9b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f33bdba66064525393f9bf50cd5157643ca5cff143c8b484bf081bf393b014"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https:crates.iocratesopenssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output(".hello-c").chomp
  end
end