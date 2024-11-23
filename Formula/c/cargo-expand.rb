class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.95.tar.gz"
  sha256 "c2f77ea53aa72c316aaf0b6aa6ae429a58b79716907b1f86fcd35451174d83da"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a80acc80e73cc1bc7817b948f40c61ebf36ebda241031300eb54412bfc39457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c3b8705dedcd11988d9b08dd6333af31915ce947ce647e7390fb52cdad7fb4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b92377de23b3de2b4fe5807838cab40216f3e149a15c0866f7fab0c2dee01bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e110b5568349205ff486afb760c15b216f245156907cd6ff7555b2d90f5ddfee"
    sha256 cellar: :any_skip_relocation, ventura:       "ccb28c347ff58c046126b0dd19ad4ab6ac36a9e2caa2edafe1877a7d63426912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45208f68a0977ca43c7ff36fb277c949dc492d1aa162996b955b143fb7a0081e"
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