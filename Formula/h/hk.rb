class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.8.1",
      revision: "2e06ed15c5077edc43e13b41b33420659a4f1b3e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4b1a98c1bc25ec9218a8b178e52b8587fa6fdff820dadf938f263e71febde19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47a81ebe7103c63296ffc8968d618a2982359edae4a14388c209612252bd7726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e0eddb5c8f61b618d06ec27e68039ce493bd4a0473a0a64bd69ddbc23e6e86e"
    sha256 cellar: :any,                 arm64_linux:       "fbb677154e24b05a9b5d2dd2620da08a414bde7d20f03605b2082c5f903bdc13"
    sha256 cellar: :any,                 x86_64_linux:      "8af41ccd3d5c444e429101234476bedc4016c74890411956e03e3d7b261b9b72"
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