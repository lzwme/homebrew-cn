class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.2.0",
      revision: "47c35ab140f92f7c1b0eda40dc138ee4f21f4b3d"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "197245572733015ec6da9936a20b371a2ab177c71a177ba164db6cf0fea15652"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "525651168e57ed22920369850b8c0d9244e9266ff60002bc3852ba7bd9b1bbb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bdd1660ab3e1a403dbeab4d25df74def80a4647c5fa5ac05c2765a29dbbf84c6"
    sha256 cellar: :any,                 arm64_linux:       "50f0e34019ea3506c81bdad348ce85673906789c7f77027908ad27c47cba6c07"
    sha256 cellar: :any,                 x86_64_linux:      "4f2bfc975b484063a2fd83caea18b6ea193a320f28b97fd4e0957b3e16fe7313"
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