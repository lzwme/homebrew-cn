class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.44.1",
      revision: "f1fa1fa4516b76dae6bd5cc49ed1bfe75fb61fb3"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c82fe915162f0bcaafa750abcb0748d7355b03e775dfb81c3c5ee9714717381"
    sha256 cellar: :any,                 arm64_sequoia: "e0f3eed0b115bbd94669aba49ad7b43c75e0ead9db5288ec99ed09ab74bb1624"
    sha256 cellar: :any,                 arm64_sonoma:  "0ede58decb11bb4f71ce073d82b8e09edbb5031def49da778940147f4a5fbd83"
    sha256 cellar: :any,                 sonoma:        "f7db7023728cb271c4049dd77540d75859c3da1bd7924ee0afa09bc5a6080092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b3295e6459cf404963fe61a9ebb20d1bfc6dd5505242b7f376a84402c048ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e413a20e2d831bab67dff2b5fc25186719cc49ede0011132431ef2a4c1f19b"
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