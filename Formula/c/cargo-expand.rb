class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.98.tar.gz"
  sha256 "97bbb66f2524a3004fb23bf091342bfb5034b3e0c35ab943209922943dc23ee4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bbb3543b70dcac954517c0d6fb3c9e5b1c6eb9dd444e7c0e09d611300dd36a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b71d12129bf80b27c3e96557bad97969c0a70b0df3a5277a9baf4e448abb28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "038e56823d6282dca1d1d87b26f609415047e7e75c48d8811ab799697f37f815"
    sha256 cellar: :any_skip_relocation, sonoma:        "f136f7476f4f1bd55d13b63ee1f6c3303c4aa3fb829d666e8691c403afe38726"
    sha256 cellar: :any_skip_relocation, ventura:       "339322675f433e522021799e5554e1fa1b5f40d428a20add0b8c38ae4a075eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed63401ef42440c302dd552fbd21293ac7fe42400ef533cb605e289b4338f183"
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