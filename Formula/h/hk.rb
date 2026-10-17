class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.7.0",
      revision: "d3ae335728408eb696027072a9440e67b4d1efe7"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cbba0d8fa8d3f8774d1a0ed701144711f4799913d39d753f5668f88993064ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d52e620fbe331181b958ad2cd962ad0c76b97ba1d01b1628882ec3a02734884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fe0b305706eaeba4739bf60a0cf5ed7dfeaf97b87daa835f7cda488eb001f43"
    sha256 cellar: :any,                 arm64_linux:       "ed4b6e120cceb04c04b2781d12134942bd36dd96c5b16d19ed67e596e253a686"
    sha256 cellar: :any,                 x86_64_linux:      "80c59f4c95026899ea95cb2c491c6171fb55589a8da7366d5fe6382ace261013"
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