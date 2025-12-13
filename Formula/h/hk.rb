class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.27.0",
      revision: "432a820653692acdaaa0f23b77c388b643e1bc1a"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "271fda0dfd468afbf70d49765501824079bc2b4702a0ea74b6a1eb7685d3aa7f"
    sha256 cellar: :any,                 arm64_sequoia: "44d82e1aa748a5aa98018d9ca262ebb5e983a5a6075a609e67f393f07779dd5f"
    sha256 cellar: :any,                 arm64_sonoma:  "cc1eae7e20554682ee7d0d8b665c2d8c48bdf17d94d727d65e5b9bcfdb710df0"
    sha256 cellar: :any,                 sonoma:        "1b68e742415781715338dc6719049529202d215d5abff989a0e589c5c99b8c20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4e1daa11f37008ff9e90221dd5fedcbfb88210e42e5197d821822e3d233d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129daf0d8703c5bf48c4c1a80a92af159cbe08f83d0b819cb07e50afa9c65f08"
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