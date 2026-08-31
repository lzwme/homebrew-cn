class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.57.0",
      revision: "6189ceff84f486ce766e9ebc6fff96eb3ef04e53"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5faeeb4e5fb3ca6296c9f9e338c9ef93baa8bcc9c8fb865fb52cb8a74e0300b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5836718ca47c79518c12e7fb006725bff2a4e893ac8be40d372294147288e9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b14a08e4b0ff972cc42eb0a64169cebc86fe73b30b8d39c0864ffea8fb9c737"
    sha256 cellar: :any,                 arm64_linux:   "98ea467f3656e7227be438ed610203a36a0548d049c957afc481953854c7f1c6"
    sha256 cellar: :any,                 x86_64_linux:  "3545b01c8caea12d955652ca2627e2a764c0f7edc65fe20bab2fd1f0ff97fd76"
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