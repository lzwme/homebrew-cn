class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.101.tar.gz"
  sha256 "c9a27d57bbbe9f7ee28c702530041ae516b931e7d6423bcb96b4280aedb1612c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a61f5494e21443b1e6d3e0159abbde9a608fe4b6bf3e2a92935269ec7f310a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a6434df356d41da7bd81162a4fc83dcc5a55182c1728963dbe6c14d136325d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "769d718b75485f7afd00079c7941cea9e2b51a0ba70bfb515e3c2772f9e8a295"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a94489e0b84831f3c875e9b8d4318efea72472ed2a2b09b042990a31bc2ab8b"
    sha256 cellar: :any_skip_relocation, ventura:       "857a7efdf89d7e9b5ea91ebbbbd49a5132e7daa10ab3d9834d8f8bb4c7448155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e465a2635b9dc19f25b7a4a121e885d1b3851e7292615f04c3786d23bd2798d3"
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