class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.4.0",
      revision: "bb2303bf2a138c4d5d27eac9604ade1ff2fc50de"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e069f2ae8bb27366c6c628a1221f696bff00ad20f0ac60e2178a3a88acb5f51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd5e7476be62865f3daf0aac48b3a31420f2400462013e18931934d8955691f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f75d8b70391ef3d5a641c5e8556243108b7f6ea801d4fd9e7c58364eb8290cd3"
    sha256 cellar: :any,                 arm64_linux:       "be26b96bd04f5fd347c08d7f9e9d80c603b9270ed8f5f65b58c13046e861e465"
    sha256 cellar: :any,                 x86_64_linux:      "20d482d18f900f89220085399f874cd48b9b6d114529459baec3cdf1506a6f0c"
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