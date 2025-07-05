class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://ghfast.top/https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.111.tar.gz"
  sha256 "8762cc8b43a41238f851fa26b56d6d6f0ba7a2cc7c7b6a771ac9684e71ca28f3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1901f62358f62f3f0294a84e1c1313d9a34c13cf0337fe9849a70133aa9455c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ecb5037aeeaaf5364ec2fc85986ab4e09d579748f84ad7b1f2abca8f5462c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "320aa7d27f9c23e40a1cf2a7e98a7498285c7dc3236b5f0b80cc3edbf21935fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4108496ffedf8a7f667ea96d2fad639e1d1474fdd7cffb2ddad78a6f1cbe0cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "3a3d79f9342e5f7f048efe5c9fe3438c388505712770d6bb76325ad4b82ed70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ccfaa2a116052f3a7bdd6214c04bb5eaa38fc071e58174471947ab01751016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b0f03e08f63ac88331c7f0dc1beb84cb2a416aad2b73596852af8e15ed09f67"
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