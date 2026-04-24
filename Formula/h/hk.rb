class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.44.0",
      revision: "3fdcd34d96533e907f8b515ed04a59c434332b93"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64a55b7a8c815ba77413185b0c67d4902b522d7e330a800a3eaae2e4b869f057"
    sha256 cellar: :any,                 arm64_sequoia: "d7c6c487e2ae22f5c1cf1ea3c5af1d24e20be06639134ea32ec7d4f4169d17e1"
    sha256 cellar: :any,                 arm64_sonoma:  "f56e2bc7efda4f626360d7d899327e8509df691374715f64b1530f3c04d87f60"
    sha256 cellar: :any,                 sonoma:        "fee044d0095902637bc6f3e8a1e1a4b41f02512bce12b948a5942a50686b7daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ccaf87a9b1ccd8bb4382871aecef4545568bcdd5f735a16ba4d81ac95a9d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736f7a7f999ed0d81d7b3fe07c7d6cb826ac6e8b5d43446c86f8127cd6f35722"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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