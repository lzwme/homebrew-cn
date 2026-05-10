class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.6.crate"
  sha256 "233ec0c436242e6bfa086082667706e66a0349609d8cb97245eabca987856a43"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb156d9a3f906c05df3243c6fd5881e1c7cc3a593841c58c04a91d6775d4d4b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02c709c4582a8afc40b7d40ddd879bc2bb01f2ff958c56c1cc6603565b838a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03bbebe9e261a2944e3fbdae91319f6faffe8bafe129813bbabab424f15a6bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f3b7aacdfa2f612a86a08ae5fcb3c31db1a71bcf1fd26a2fdaa47b69f36b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c649b4b683048a49b6bf5c4d41bfb3f183a1c41c875f53b167d57e1d8f61dfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc299a1824ac4f76f129b76a154440288184913442f527820d343029de3233ed"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end