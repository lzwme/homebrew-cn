class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.52.0",
      revision: "849757505dfc73cfba8f1f110c67d1dad99dfb2c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3860912dec5f68726d31ac53cda56329a1157babc7985e90a4fbcb769631a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e701471030a9fdcc2eb0fde49906212e32598b93e0fc63a381f3c481d2ebf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575166fe182090fb8755d89bdf2ecc3304ede90cf33367bf7861e7561adc9fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "97e2491ab8b2aef41b5d86b2396aa6e71f2ae394ade54985a2bbd739c0e0fc95"
    sha256 cellar: :any,                 arm64_linux:   "ea028aab6271cc884444d32f00f8a98f96025406aef75578c9b57b7da4bcfc21"
    sha256 cellar: :any,                 x86_64_linux:  "432e9666b32378b2cd5945452785c8f341743f40a267890b69b1a6d10090d491"
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