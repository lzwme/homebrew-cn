class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://ghfast.top/https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.112.tar.gz"
  sha256 "cc11dafb0a13f5c71468667c239fb0f75e1ef97ca12c75946126b9943f327349"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9bf7cadc13d178d60b84db626ad60f828d0647592ec89d27772394fd356307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa938610bda2f42c5a2639ed6bd1e8000c27d4357805da91217c95353931166c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb0801b541073fee709af0be0d886d4181c0adecb8ac5c28937854b782f75e52"
    sha256 cellar: :any_skip_relocation, sonoma:        "6748905c6bb6087fdb8065ca993be5c0c33ca1ef1ad84f5a64414d49611309cb"
    sha256 cellar: :any_skip_relocation, ventura:       "5f11cf4f01d65454f4e566e22de18a8bc1e8b16b1d6a161f53384980cb6271ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6632566ce52140ecd8b00d2cf3f82ce63f75c50589456e3d2654da9c042b027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e68dff382c7547a83fc63dcb1f16d6cbf637f7fb014e9202f3fa3c1b7f13f091"
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