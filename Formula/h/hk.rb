class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "d186fbce9889f3058b3bfad8bc9a2bf5a83c09e3cad87a7a3d3fde2b58774499"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2b27e70dcf1afec81baf1ab2f57440088c443d36de7709bf789c76f5a9d9a3f"
    sha256 cellar: :any,                 arm64_sonoma:  "dc88aa518a03e931261eb35ed222d41a0cab7d65579e768cd7abce19f70ed229"
    sha256 cellar: :any,                 arm64_ventura: "89c251c2354b4c766e82b9b8fd178fe352d7d6eec0bcc5d47310544318fcedee"
    sha256 cellar: :any,                 sonoma:        "d6e6267e7dfc271c4e9dfc636e553e033b1aff70f637c2dec8fc31a0f5d7fcd9"
    sha256 cellar: :any,                 ventura:       "88a68609cd5f447a98c071d6c97612afdf54e437856701d9a5b227565d3eac85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4f0d56b78d4b1793ccd0461b5ea2ac1825530bf5c4bc8a0999d580d79c2686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6fe592f7cdee95e4f77230bc52f20aa1dc91d6332560c279253a164fed27830"
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
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end