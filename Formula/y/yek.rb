class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://ghfast.top/https://github.com/mohsen1/yek/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "9fc458cadd6eb1c97dc84f2d9dd166c8579a4320faca7d0b82e1313d656be1b3"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b1cf3e736236db4cb7c0fc86c643649b618f6886eff9834f8fb6b8af00615e33"
    sha256 cellar: :any, arm64_sequoia: "12a2dcd97caa2bbf02a0361c4bc492e06504b7e95dc40b9136f991602cfc5734"
    sha256 cellar: :any, arm64_sonoma:  "0e5a8ecd38910e06fd9f62661f7c6e08e42a4a11017c8020f37a5ebfd5d07714"
    sha256 cellar: :any, sonoma:        "2655754ad2d2cc6d417d36ec93e255acb804a9831a4682fda1a23fcf086439e4"
    sha256 cellar: :any, arm64_linux:   "0ba9eb2bbf1dbba364a2aa875fe6d6fa3f3262239996dec4ee472efe3a709d4c"
    sha256 cellar: :any, x86_64_linux:  "59ffd6f996dbdc9a6ce39449ba4ee54ed18d54b6b8b70dd8a46c9b73b31a4940"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end