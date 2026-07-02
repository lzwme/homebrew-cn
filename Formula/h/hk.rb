class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.49.0",
      revision: "0050eccff25c4fc27cf2727af62653ef7886aea6"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086b7668b7b04134a5ac3e152180fdfa9e7a8a3c404bdb46982592aefc23d1b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1989065cd1834b6f94baec02d7ae932da3f5a581be963ba163e9869eb44313bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9e0e99476158bb1213e15e9430cbc1c3007f182f7080911f3107fbd8f279fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "07887e8b4c285b723c90efc39f8abc0d25fc4f339fc8404dbd74be4d5c58a7af"
    sha256 cellar: :any,                 arm64_linux:   "cd465c787bfd87e57afa5870cbccbc7406961fcdf34f58410238f29bccdecb64"
    sha256 cellar: :any,                 x86_64_linux:  "8fbadcda963f1ee23ab75ab78233310aa211b6aa52b22a659ddaa439855f463a"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
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