class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https:github.commozillasccache"
  url "https:github.commozillasccachearchiverefstagsv0.9.0.tar.gz"
  sha256 "df5b8a38f6d29f438dba0be57ec2e6c4c87675c7b9bb4dd2e93d4c9375ca797b"
  license "Apache-2.0"
  head "https:github.commozillasccache.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33af2ecad32ea80ab0a14ce4daa05b3ac4a8cbad641e42fe2cad0febb65fe379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904bcb55b4a124be97a9ad1c2e3c3cc7a37dc0d046a06b08c7f8d974bcb7c587"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57eab64240c1551072d6c7f85e068724a8b58f7e147237f54a8cce02aef5a354"
    sha256 cellar: :any_skip_relocation, sonoma:        "44b754073dfd9114e3b7377eab31aa094825f789fe7da9f12168424eeac8430c"
    sha256 cellar: :any_skip_relocation, ventura:       "b4c6654f68a850c4eaba1ca1b4ced4aca7a84b1bbf6efd899dafc40fc436bc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596aa94b890089790430061ddb86d2b26741ecb99b1da18d27a92736426ed34c"
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
    (testpath"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output(".hello-c").chomp
  end
end