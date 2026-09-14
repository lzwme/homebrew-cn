class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.0.0",
      revision: "f4ad840548897eaffedc55a28ff262167dda96cf"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0cacaab6796a9c720aa6ba3d02828a5d5b3c0012f2265b3f3248c6bde25a697"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c90ad944a4e4745beed60cef49d77caf5442255b296713e4e5413a22c320896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7aaf8467742d3ed4d04f22366f15ca4e151b1cd30c4eef693902c1518f0a172a"
    sha256 cellar: :any,                 arm64_linux:       "114ffecd1171123573c4136657824117f4bcc17654db0b356609b76797ada37f"
    sha256 cellar: :any,                 x86_64_linux:      "59e8f18981ef246d518f5706e718c4b33e4d5d142619c0ece929dc74a3ed5e17"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    # `mise run pkl:gen` - https://github.com/jdx/hk/blob/main/mise-tasks/pkl/gen
    system "python3", "scripts/gen_builtins.py"
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

    system "cargo", "init", "homebrew", "--name=brew"

    cd "homebrew" do
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"

      system "git", "add", "--all"
      system "git", "commit", "-m", "Initial commit"

      output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
      assert_match "cargo-clippy", output
    end
  end
end