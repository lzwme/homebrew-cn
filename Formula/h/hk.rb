class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.51.0",
      revision: "8e26af2d614f09e2c803d4ef9f699b126a188028"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b21aa935de6c96827e8636a15f93e3f3da44d37ce0bf3620091370437d2e050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1e233896531afc7c833e73af43fa2f401a0814429a8017e3acf2ce11531405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "372afd609680a0b755ee0b1bcac4b91521f87dca757ecdeb6bd389757c2e612a"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b42fe21716fd17da0181845db5685cb0ad2e360303ce94c2b9df3c7cfc024d"
    sha256 cellar: :any,                 arm64_linux:   "3818a775ef0b9a474ade5879b6a1c92574e41d16c3b2224fb1043880a7595e40"
    sha256 cellar: :any,                 x86_64_linux:  "3d4b09b408f48edb75c161ce88bcc78887083351f31bbefd833240b8a5e82c43"
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