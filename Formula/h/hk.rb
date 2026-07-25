class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.53.0",
      revision: "524fecd9b0cbe24faae47ef2080b19debd35b61f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c48a81f0286fceb117be383ec8327dd57d960bb127507f72906c1a29dcf1bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99094f5db8b3e10a9340ef66b5bf41e98fb5744a4d9896b6f12ffed03c89be53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2939d7a3cb78f04874c01881722431d28e7046e69e27994e0950fe2634f38d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a04f1349da1aaab6f180389c3726d99eced9cab1f0d1419f5e11d8f61f5d35bd"
    sha256 cellar: :any,                 arm64_linux:   "d939c2a8e07249c1ecbdaf7faee998ff827583f30f53f7b134106b681c5b071c"
    sha256 cellar: :any,                 x86_64_linux:  "81b84e8293f38f2e7f936852fa808ffea6429c1fd146015001887ca1c9f3bbe7"
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