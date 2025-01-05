class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.96.tar.gz"
  sha256 "a3f163fe2cb4f1a81e8eb0778b6534795758e4181d4a230d79fc96b7118c104d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f22830e4d0406333b025f57ef6fa70661c61b1288eb42b8b9e7ce7a03873eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865264436ce0437bbc54919e11a2043ebd383dd4e159c0021117b84f870a57bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f546de6bbbec855307430e590d05132dd4535928cbb1b8e11ccdfd07c63af768"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6998847b010ec1a78bb36078399a476dedaa474c3e085bb8dfe5ef60de3adcf"
    sha256 cellar: :any_skip_relocation, ventura:       "e6e7f5e83f9b1e1703b1c10ba18655c276602b0fd741ba1509ce0d6b87f6b5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12238b5f83f88f6e1781210b721a173c3bf2bb8bcf7dc3aeb47bcbb9a3f6b8e4"
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