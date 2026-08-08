class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.54.1",
      revision: "164d17ebc0b9871000a98d21edb8464489cf157d"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45772c304ea5bdce28dc11478f5563184f431ec9f7658e87c6d5611c97a34be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe375a99be79d3d8ff324db0ab97d61a6733f303602f8bb3dbc6aced98f03241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900337d2dfd923d972213aaf19c816530f9b88cffbbc1c20f6f01718412be2b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c0be6991a08fc162c465ae2ebdd28f49aab2fcdead557ed49912ed0102084b"
    sha256 cellar: :any,                 arm64_linux:   "873761752b3bbe8069906aea04dc6a2d5ed1ace4474cd6d164ead024c0240eaa"
    sha256 cellar: :any,                 x86_64_linux:  "16470670777d1d873d575a2280f574466b915586f96d8c245cbe729ad5479e1c"
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