class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.55.0",
      revision: "291444625d5717d48e7ee5f009406988b026984f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b921b8b2e558e3bf00e8adafb993597813d08295bb0af6e97bbbd6e6d39cf2c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9a73380b413bb3eaa87bf01a59254f40dd73758312e5ce40c28bebf15ab879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df760be4d2f5de3ad065e81e7181a4d9866b0206d9a0cc595a944414dce5c1b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc738478b0c4bc10d7f4734f6d13d5da6721fa225efc41629b07767d2bb589fa"
    sha256 cellar: :any,                 arm64_linux:   "f908e131b26408c90a4b48732614b47380d57a3fe4080d7540a042e1fcf592da"
    sha256 cellar: :any,                 x86_64_linux:  "4c7f930da9c93af9ef289e028d25c5fdf014c51d4121d7ccffe82fcd06fa9718"
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