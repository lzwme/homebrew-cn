class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.97.tar.gz"
  sha256 "baef7295f99a584916c458f14488762ecbe49af0000af8eeb3da1a39da172f20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02420efeedab4cc5c9b6f1e6ccdecd6f28a76c366d155cc246a750582dcadc4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da30279b84139743bc2adbbd8d46929c8c44d4db9ab749feb8999618a9001a11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbae2d01a958e249e708ee64d98f883ff34f8897d36059ba93bdfb4ad16c5b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f925530bb6bd667d233b22d2ff9dc3793bc3c525c05bb1e26549d8d658d7a43"
    sha256 cellar: :any_skip_relocation, ventura:       "563106d79fe85e0b764e5b3befbc8c5bee61c8bc909f5be2eee555e059611a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da1fe79528389bff4aa6db3f45becaefe6d8fb57568ba39fa505f75d16d4ef1f"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end