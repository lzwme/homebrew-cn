class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.7.1",
      revision: "be970a0958068103911ec22eaa57de516b8826c9"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dfea01149b089022e81cbff2670b722cbac402f88802297eb1d4d0c45e15326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d2ac420b21bd5883fcb8dccfb3b0c0e2dcd9246e4df0f04737d9a52e1e22e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa9a5f4562950b47985f3444a24eaa5403421dfc11d6bafac0c202cbdefc1628"
    sha256 cellar: :any,                 arm64_linux:       "e0d3bb20711e130a59df119754d3df922e6de0d711580085a3d622741f13ba33"
    sha256 cellar: :any,                 x86_64_linux:      "85049968b0601fd241a556e31c09a58f6c82fd428fb2379fa006acc51b1c2e91"
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