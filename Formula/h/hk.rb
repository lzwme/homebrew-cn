class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.41.1",
      revision: "b36edcfce61b753c83ce14dc4814550624a0a7ce"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6ea2132169c3a83b82b80dd82e49bd60ff46574006a2612d5c679d755326f89"
    sha256 cellar: :any,                 arm64_sequoia: "3f5a517dc1cf714d48bedb9e83bca83c2364af88e26d80b8858fe125b5d6a155"
    sha256 cellar: :any,                 arm64_sonoma:  "990a7b360c914bb49846501de5079cd2c4fdaf0627bc1ccce453458b411f38f4"
    sha256 cellar: :any,                 sonoma:        "20ac0f7cb8856cd64a9e9b56af8b0b548854e55b15289c823c5d11133ab12d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "777f179497fa0e7de5a887abb32d63ad84ead05b3dc407af26b5b9ce2c7952fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a9fb0c1ce21e4bdaedf5cb18f5a9aa3b411c43640b6ac80d32591fb4342b6e"
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

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end