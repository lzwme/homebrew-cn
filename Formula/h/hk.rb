class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.5.0",
      revision: "f57261aea0cf5a57fc85274ba2c522165e5284c2"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9639d293b79d587f9c130a32c768bdeda49fe2a9d254b1fb14dec1f7f18c11ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d061597c2190e625ead0d37cae7d529b953cce45757d20ffa7d6a9b88a20ae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6c34a150c82ec0ec935b54d20ddd37cc5178ee4ab5bafbca045e11cbb0a042d"
    sha256 cellar: :any,                 arm64_linux:       "9339e6a44e6235163a2e40d130711809c0ef1975685bea2e68b62d424878cd50"
    sha256 cellar: :any,                 x86_64_linux:      "130f6fa7475da210f612c5f06232fdb67c52a5d65062aca8723f0f8f9161cf5e"
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