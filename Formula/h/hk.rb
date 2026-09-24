class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.1.0",
      revision: "0a9c95bfe19dc4866d965181f6fd49ac05fe5b2c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "806ef51da612a0bf61027507238b52d8a51a8f86b4bc8f457dcb36a1ab3ec4ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e8bb23213548cf74fbe5232c11887082289a6f692a8c69e3a191b47e581b310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c02df9e714b2d7781818887614affebff16c79a36d5784f2d619b3ee62c6ecac"
    sha256 cellar: :any,                 arm64_linux:       "7db3368dda3ea7eb4ff560ec4b7822f6617612ccfae93c3391b086bc9b9ba972"
    sha256 cellar: :any,                 x86_64_linux:      "ab843f733296c0d60289b049a7c37b91702842d041af8e747e3f26e54faff1a9"
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