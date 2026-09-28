class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.3.1",
      revision: "07d39997a32175873d104950f185400760060881"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dee80ca928f00d7134e20292a214408521fc17d18e9a9a2e2bf58e2818e3acfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ed535e1b07a869b93c98fff31f6d0202d1599a20f5b169112fc080ab4055368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ad017ccd81303c97d44bce21f7ed7ab89b074de089485e172a87a165f51866f"
    sha256 cellar: :any,                 arm64_linux:       "3ec73de8c160c49c1251a3da3d3191e22f15d591a4bc33152b6ccec1eabd0141"
    sha256 cellar: :any,                 x86_64_linux:      "212310e4068f68a3406ee4ea7565fe5a9357c322c97e3d628dd584de4e07e1ac"
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