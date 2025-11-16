class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.21.0",
      revision: "276bccda298fe16066131c35c022e659bb8b4a5f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aabd97a80478abf92bc1a73de1f720bfe74e4c6ff1544118c86a63944b575be3"
    sha256 cellar: :any,                 arm64_sequoia: "f41011e6c2c54010b54849240844df37ba30414b40e26539ce6c5365dda88fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "5db4362b2ac6ac85e61d27f51e3a92d714d2b2d559962dd16049bf73acfebeaa"
    sha256 cellar: :any,                 sonoma:        "b699d1c989570025dad9d404671e6fc9d4428f69186d5fce844f8a2361b47fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1936d77555098588c04facb3b0c9465c00f36caffe3856bf37d7bc98d9cf9058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341368409e05b2ab08c8e7c109f717c32a610b6843f7e8b358aff75e56074c66"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

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