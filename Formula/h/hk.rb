class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.8.3.tar.gz"
  sha256 "90a2fb0c59d2711e82752b873c04ff8697e15d69d4dce7bdc48b9aa5b0696ea1"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "064966a26493bed03a9faf1e2dfd6cda8f856f8c96489c2bc3eb7f0adad07839"
    sha256 cellar: :any,                 arm64_sonoma:  "ef43f912b0f5f2628cda32e1796cf86a685cda0ae816d15ba0568af8818e580c"
    sha256 cellar: :any,                 arm64_ventura: "0c0a827e94a6f0368f3fb16cd53f6d5f509bdc2d99444bb7dfaf3ac17652a3f8"
    sha256 cellar: :any,                 sonoma:        "eb72bb62b71a94db923b2fe4f6a82086a67496491b3a5777d6b70fe42869e83d"
    sha256 cellar: :any,                 ventura:       "d6251d8872b07b4934942ad7a7135af204ba22aedbd892e00f14a779c0836b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f040996f73cad83370bdbe6be452570097250cc6e33561093dfd25558be6e200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b6da7931f98e0ded4edaea30ef49e9eeda97f0f6e7d02beb17eb3242a40b2f"
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

    generate_completions_from_executable(bin"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hk --version")

    (testpath"hk.pkl").write <<~PKL
      amends "#{pkgshare}pklConfig.pkl"
      import "#{pkgshare}pklBuiltins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end