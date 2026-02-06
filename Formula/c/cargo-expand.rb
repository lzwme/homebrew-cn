class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://ghfast.top/https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.120.tar.gz"
  sha256 "354d77d3c4ac4fa298e81e4014c88c1c353f36d2f64677f8f4e0318dbac3641b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76f968bf23dbb7869efbaafc6fef7d96db4230c14204c732b1f90c3645366e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ae71afe85adfe79fb0a99910f85a0a797d0cfada7357ce0966183df7bb95f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819c98aeaaf71880c77684f32d18ed847049505d5adc976b9dc2359098cf5e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "8426e8356a68503916549b455e7b7f14e1ff3c37c0c1f0388f84b994ee70d52d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b41e37d3217e2169bd51e9e5fa6e1077da3e2e3f0b724b63355e16400a40d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600586e4525c0a8c6c0930ea5ecda04553d6329a7a9c5805908c7a356c10e42c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end