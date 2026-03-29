class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/4.1.0.tar.gz"
  sha256 "c5f90fdcf7e0003a345993f3b69981db20715050a43ff984aad1b1bd5a1b02ea"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e38bb478a91c419650c3918d8ea2662aef36522b328e48ff01eed4fd9c6212a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da028941f39d1d45f6cce3822e9d8425871d39ace451e79f23b4a5ce13cff18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97a7fed6d73d97ce1634380683da4401437127aee5614d5d1dd1494b91f637f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcae18e85a8b7ce3cd26f4803e3680e9c0b00b6a3cba0ce88fcad2d7347a33a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30cc024e1a71e888d05aee816f3416826cafbcbffe7f241b3465f40bb313b8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d435046da90f8d8f77bfb0a02598f45369f1b8f03653312c19aa211422c10b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"
      (libexec/"lib").install "target/release/libexec.so"
    end

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end