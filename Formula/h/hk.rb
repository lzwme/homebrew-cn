class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.47.0",
      revision: "f65e3c5794cfcd572cc5fa37db0c8953ac791f36"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a75195196ed66385593a285699579aeb68ea79f1cec9ab98840f466b238850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb040595ae3969d9a9f807d1f48d750fc3df690eb9ee0cab71b293c7b73dab59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f75ba08e0ba6c5185fe41ef9c4597b3eed9fc02276a6dae39dfdcca2f3b66b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ade929ff861a7321b9834be0d04b8a9a0783cdc269611ef0c5c3ef2f5652899"
    sha256 cellar: :any,                 arm64_linux:   "b6909ede9c8cc40fbb68af1dca5bad2e7c26260f210ee28d3fb2b1c52d493458"
    sha256 cellar: :any,                 x86_64_linux:  "afdd7a5fd3ccd05a60f4afba067667d014129705fee31479b77a5f35b04aabde"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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