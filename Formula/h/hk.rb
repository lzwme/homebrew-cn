class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.36.0",
      revision: "51a60d96a30f3ee3f252eebc8b01bb744739d235"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4007ff464f2b3e45736b6147ab7826366466b0566554402303aa033d7d02e9bb"
    sha256 cellar: :any,                 arm64_sequoia: "ab276933a9128df9c9a2ca55f63906e5208ad36deecb17ba7f8de4be0587d699"
    sha256 cellar: :any,                 arm64_sonoma:  "52d677fc3afb8e5e578f4187124b8c6826c6686213a3cb456cdcd76b87cf2cf0"
    sha256 cellar: :any,                 sonoma:        "44460b232e2212b9e24a47cba6daf53620b9730f31f67cfd37513a1ec2ae1fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29d2858f287db46d23437ff456ad7c8179d7774e952903c47b3b8ee6630fe2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff473db9fb15b031115c65bb8f0cb7ace21a8caa17c2176b885eafee3f01954"
  end

  depends_on "mise" => :build
  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    system "mise", "trust"
    system "mise", "run", "pkl:gen"
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