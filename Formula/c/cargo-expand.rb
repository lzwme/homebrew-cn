class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://ghfast.top/https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.115.tar.gz"
  sha256 "fd34dd9e7bee6088d78aed4347b723a709c9c1a55691fce23fc487af21e3f175"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8441f34e86d3173ed817087645a4bdd6566a71f59d035bb8b129b02784c975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb690f46ed634048e42f0e1029e74245bc54bf798662b573f5d30e3d39acef21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24310d944a6c2492ccabf1250a219b0ff844d5616063228268d2fea83dbe78d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "636f727786c231866b3dd28b0e5bf5cedd24180fd18a513a90f5f2b98de19696"
    sha256 cellar: :any_skip_relocation, ventura:       "d727b2d4c3d6e1eca24a26189c0a4c90219b527c5783b8f23daf073d758e2ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8eda4f8df627342807c1eee326f7b2c8b3a3976c6082cef78403091fd991ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a51e6c714b623766aba81060e1550c1712a2ed1f0d5c09a9d3fb13251d15afe6"
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