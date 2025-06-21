class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.110.tar.gz"
  sha256 "be2628aa4b16efeb0bca1c0137a37b79cb93cbb82843e2440461ba54f793d43e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c9e27253d09f09fa17e623fae5d3c4b5819308c9e0eb636f511411aea2cf7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1899808a51a2259798aaf7809efca4f13b5a428aa5181be748e1bdf694448cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b589c054d3e734e1ceb7bf03250955a5ab59ca45b1cbe7229ec7bd6b6ae25e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "30065032502181d096fabe78860934e3896e55163f62941e8f5f44b31ac0d7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "9df43dd91ba5738d2e5f1e9f03813581598d93e1be914fb90d66d904011c2566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27219b85b9640ae57794a92f977552c5a27dd8c8b9a0469632614237a48bd688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1adeb69efe952b2edcf551ba12e445186febfaf0db63c35002391bbd3c948b16"
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