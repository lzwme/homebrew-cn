class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.3.0",
      revision: "169c5f15ce52ff97b0a3693c3f9f30ae09e0d60e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7113745b9766d07bb888422443bc65fcc8a12a51ea6b066d168c328316974684"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fbf0b92c6ae5dfd0f88d06b297db78465fd36e71c5ff5e32553dff1ca43f75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "877be73b997e35f43dd071d451d2656e09aa956183f6f6647fbc98e170f39a97"
    sha256 cellar: :any,                 arm64_linux:       "d570a36cb7dfe0240f8ae823b35f11c11d3a5270fd50c2c9cf48684a3fc0f30e"
    sha256 cellar: :any,                 x86_64_linux:      "a2b2a4ea80001b0cfe3649818c9350d25610fd7822739b3a9a5710edb8eea28d"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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