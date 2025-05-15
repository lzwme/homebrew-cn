class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv1.1.0.tar.gz"
  sha256 "c2a338a8d9ed574ff2be84b5cc84a904bdf311e0c635736e4ac9cd2673c9fb3c"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40c6717baafe8d20a8c4ae9150ca357489ebdc92dd6dc56ac8efcd9ff775f81a"
    sha256 cellar: :any,                 arm64_sonoma:  "df5fb743251e5a5b7be64f3652e0e5d12e634cf9b2e74edd63b07f28ca4d7bf7"
    sha256 cellar: :any,                 arm64_ventura: "61c68e54443ba445cda2dbfcd995976cc89102f2cd68e36202e5287191fd7b04"
    sha256 cellar: :any,                 sonoma:        "c5a73b3d27a0bb95fb60a0f19913ccc7c2eb3cadc3cc807192788f642c982ad6"
    sha256 cellar: :any,                 ventura:       "a554e87a809f7deb1baa78e18043ae9f99130852b67f1a94157c77af1b0c023e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134e8cc2e90d5dad534421bd8196da6dc355db5d1273e4c37103e08375c022a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe872014624c193f20827165321607f6dbdc5a8ef163af6926e086fa39e47377"
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