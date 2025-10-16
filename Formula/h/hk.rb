class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.19.0",
      revision: "29b195cde8be9d36ecc936a3dd34150aa71e964f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8493ff66f00a95e2a719b478f70c0d97ea637d6644c3f569dabcc8024d6ad773"
    sha256 cellar: :any,                 arm64_sequoia: "22e7dc7bf26ec78cc07cac3b20d3acfcff959119d87c80bbbe6bd3520fecd3ea"
    sha256 cellar: :any,                 arm64_sonoma:  "2d4c885ececfdf65b3332b3205af9929348eb9ee9257f7013a7fd635a615eef4"
    sha256 cellar: :any,                 sonoma:        "2572c9d2543e9ab97b20fae695bb4a6467da16c686839abe6928a3d71a3d4e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95daa74f7d7f715e251cb321bdf86567794c6cda2ba8d0bb0024c01db4e74ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3860a995f362cf14509793d4dfce4be0cc2378ea1be6783f15ba47021ea601"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end