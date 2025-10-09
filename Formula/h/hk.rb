class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.18.3",
      revision: "4cdacfe4dd77677ffba6c7f64a772c1456143e36"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d858c29927787e9ff5212c746aaea177c0275d8f45dc7aaab3e92df19cd30a7"
    sha256 cellar: :any,                 arm64_sequoia: "e7622fdeac73338c6423e8e576bb57853af2168bb0581cd6700ef97dcc178334"
    sha256 cellar: :any,                 arm64_sonoma:  "9cd2e9cacd0d034a92154cbe0a5edbb707104a24ddb6733e00c82f9398dd0bc3"
    sha256 cellar: :any,                 sonoma:        "e3ba28643a6d29b7743fef639b458a79d6a31fd8bf29fcc351e0a4ef0d52659b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6478d23467801d73a2df3b27115e3a8efabfbe456bdc9ce60dec09cc921e5175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b354e9f0af5356326cb480192b550a1cc2e386eb68e4173d40bbf8d07905d8"
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