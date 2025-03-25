class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.104.tar.gz"
  sha256 "b7ae9d9446acccdf14adb2d7d0146f17b863121101facfd68f603c29c4442180"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39208dd173710e175ae57ff0168d61d5a5f73493ed250524e3887d6da784588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb6aa5c973552ab93458bf4b493fe2cecafe4c025578129571d1c8d675e0f5ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e07ef089f411320a42ee8df9c097ce0120fa4fffb9d4d05bba7087f58a3a94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9229dc4422ff2ce6106beada047c9d58446c92182c2c3e1f258247ef0aa870"
    sha256 cellar: :any_skip_relocation, ventura:       "c58608ae019a5f92ce2ea0bf86e58a5311eaa4bf208ec41704570df534ed49fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93fc42d58dc75c52fdc297fa7d0369c81cd2f5749077ded62b1656fa9c0e6840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e800f9f9df16421e259cea5148550d778f899d33131ceab313ca89cecf4efe19"
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