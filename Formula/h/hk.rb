class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.20.0",
      revision: "343bb4942d2835d51a6bff384eecb80f62926b50"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00737ba1d4b151eed47f04c187b18f086f08717d898cd9d035d7847d1c417df5"
    sha256 cellar: :any,                 arm64_sequoia: "3f5d479f3a1c4c35ad31e8242bfee4b856ee1ef145da8bb2221b1cf96d8b6c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "d07a9b9e3cef27c0ed923b352c4e5ce4160a89594a74d6e9c0c516ec4e5bf9d1"
    sha256 cellar: :any,                 sonoma:        "d0b78c34b683d3cabb8c3ee133d0a46e949c06c796e8ec7772731752cde2fac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab731d4360fc597e54f4ba0cc5006f9b8bc86f83ed2da0a37ad10017b2f10ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f72353af7fd943ada3d8efdf4c1023ca543b7a601967f7a9d62ea114b6a725"
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