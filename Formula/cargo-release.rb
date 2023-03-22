class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghproxy.com/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.7.tar.gz"
  sha256 "5d80ce050a7347c5d47a153fe09b4e0f7783deb0148e527622326c7c7d20257b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "567b4cc1b28c32c03a790542638788fc5bcb10fc7eca45b4db0e43355afd4842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26fa268b688d71f8445fdd69ba6aad5490cd0a5df063af1a0e0e72b45143bef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76900c87854d717e9bc184a2b77c980db068a6656a81a2418ff21dc4605f014a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7948bf11ce12245adfa771a84f2ba1818423a074b896bc2b0d1757e94fb8ea"
    sha256 cellar: :any_skip_relocation, monterey:       "dc28c2b369f625ae3d39e6e3f4904f870e20bb456358f2bf74dee0fbb9377b84"
    sha256 cellar: :any_skip_relocation, big_sur:        "26608b676db5bf02ab5f3ef93ce156786b766e36da560d17294b7b7374a61f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdcf3d5b9291d3a2182a1f810e2631b9fb37aa7464dbcfd404d0d456cc73298d"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end
  end
end