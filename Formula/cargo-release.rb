class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghproxy.com/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.9.tar.gz"
  sha256 "20b2effd9129a4e13c573203fff128b31c4466066a0fe8587d2269878b0ff206"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e900cb584cae0e4e82f890aba40d2c138c0f66193287fcd71503908cf022b5d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aa62d4afefa8db7bc8e7d55242ba6bea2d537f4948cab8c6a3f7c9dfb073f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bce913c31896dc6151685599177a26cec0ab9a49a8b533e4caa506970864c6d"
    sha256 cellar: :any_skip_relocation, ventura:        "50e02e51f35860a65821a4e8c0152e6be42be14f267aeb55077ebc3d27222a2b"
    sha256 cellar: :any_skip_relocation, monterey:       "4628f726aaa945e494e1e0462a37d0feffd8cf6e544c9298a00c0658252722a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c2cda07f4221b7bf9095502a7de19505c5ed93caddafba2eee2ca42cfc7f57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8ee3d6b9eef67c6e3929422e992523f3b9080fc71321836ed84beb7bb7b954"
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