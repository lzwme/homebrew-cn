class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghproxy.com/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.8.tar.gz"
  sha256 "6607cebbb460cf4372d7c3473d8dd333f87a371113c064ba35f742cb83ae7ee0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c82d4e12c944494778cf3f857a0b22a3e2c039164f0e63964affae32a93c8dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42b3070fad9e9cc798fd76ff8c7fb5eb0f2ef4c64f9590f444c90ced6cbb7411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94ca9e2ba26bcdd82ee8e7ca962bb50e1c16e7db02966650343f55a97edc5fc"
    sha256 cellar: :any_skip_relocation, ventura:        "898b41a787a4a043995cbd347548a1763b0ca695f4eb9f4e30583c01c28df5e4"
    sha256 cellar: :any_skip_relocation, monterey:       "807da9cc8641ef34bc86dbed8b156443151742dc47b1ccc67f94aceb12b17979"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddd89daebf09eac983b81dd1e7944bf570ad3e5887f6f5d57ea40c9fa947f3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4ee9ab2e9a0802a0307febe757a75976d368be3e15900e7e35e97414ff5d77a"
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