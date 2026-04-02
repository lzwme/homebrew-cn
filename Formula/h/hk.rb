class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.40.0",
      revision: "1d36621a06e312ff3f4b3b845754bccbe4e53773"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21a7135c85d864b771e344bb50932bee5406b3dd40d4e6c8415772798abbc65d"
    sha256 cellar: :any,                 arm64_sequoia: "df6d37d1214a80e595722c2f32b9de457fc64a18062bcacc3a45a5f9ff0f3482"
    sha256 cellar: :any,                 arm64_sonoma:  "87cbe6eb372e965feb45659fd2f7d1d780439aabd743f973ac56de8c87b072c4"
    sha256 cellar: :any,                 sonoma:        "6a8ed6749a83b14fb83ee860396c4be7d12fd8834c2e93de6b0966bffe892c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee7f2042bf640e6aa56109e6672a0acf7a8457ea1f938f0ff8f45688abc34dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd39d6911c5dc584574fc8d23fbca83f9509d4249bee795dd1b40a8a66e303fc"
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