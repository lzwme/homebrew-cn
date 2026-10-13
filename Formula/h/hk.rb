class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.6.0",
      revision: "b21071437ddf12cfd6952c109a7d7cca5356236f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f3f8911920d50fdb2035dac0eadbfbb96d4ff4850018611c466169c5b07f7a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "453cdb6482006c227be1a92775f93bb763a4a1285127c757614f1783259e2b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b58afe204588c9d752e65cb2edb37e79e8ab6491614e8f87ec48124b36e965a"
    sha256 cellar: :any,                 arm64_linux:       "dfe4c890707a7b106a36b31cc41d46e6911ece5069f2229139c1c40b1bf7f742"
    sha256 cellar: :any,                 x86_64_linux:      "55abad8d9e5481b47518e6b7e29577e71268fae296ad68d3390dfe28bacce5ae"
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