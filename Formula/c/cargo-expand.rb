class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.107.tar.gz"
  sha256 "ab217b3e73b06066c95922404889c229d9bf9d9ab41fb9cd21fa7ce43ff145fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adba9dce6744f1de1414aab9004805c42232f69218476ac35d003553051bc990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17a220fc046b0934f9c5a348eb9d6b851883b90b007d37eb4282ddc5be0c84f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d81b9107eacb35531f77a7d6ed1b96743f2dd5df83f1288f1ba25f84b3c6e5b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b3748c280e5c421634ff47ce6f77e2a76a285d7d2760219192765ac7c7efd1"
    sha256 cellar: :any_skip_relocation, ventura:       "600c304869667e91bf488b5214ab89285f0eee9d63b0bc089cf49893b1e86339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da30ca9a1f42eefa877bd52da7d75dbbccc18b950884a5c5418f5b5b38f7b199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d3a64f68fc47505ed1bc6957307f3bd424bf5394d8e620696851f9d4f43b07a"
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