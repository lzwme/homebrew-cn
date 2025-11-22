class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.23.0",
      revision: "81c82a81cbe0dbf6250015ce804c94356c183a74"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d41b6e2ecb7d35c094f20f6958aef0df32c85955687b966c526567381351bce2"
    sha256 cellar: :any,                 arm64_sequoia: "3ee076855a6e73c51b1bb397577fc8392713258a24e7ba6cce0c62402b52ab9f"
    sha256 cellar: :any,                 arm64_sonoma:  "1993f60a0dd7f1cc359f57df96a795e10ba56ac1a7eea38f3c174f060b0dc10e"
    sha256 cellar: :any,                 sonoma:        "b9d018968efdae83f657fe0b4b7b05b1636620b13325be316acbef0de2735124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebc1631a67c824c476c7e49cdb3efdb4513d2311e1b9680abee7986ab479ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053563b392927f7fbf121b9d0ef031d5863513b0a16d1eff4e091567ff70ed32"
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