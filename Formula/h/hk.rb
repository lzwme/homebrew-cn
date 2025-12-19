class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.28.0",
      revision: "6bfc78ad514959e5c111faecedf876d9739d986c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0ce098bbafab57dbc6ae5ead132111b658f391260d0aa18170b6b4d2fcf8b83"
    sha256 cellar: :any,                 arm64_sequoia: "7c819ae5d0229308da389e59f370c87ec8ce959cc44957d8996f1821e4c6a786"
    sha256 cellar: :any,                 arm64_sonoma:  "9d1f4a71bf675b69bb69be8e3976c97e2ee5c2f09c6b6905ffce39e16e370001"
    sha256 cellar: :any,                 sonoma:        "8709830fb73a79c33375cf9e081c6486d5f4edea898d388357554e8cf12cfbf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f21392a6f57dd656c676c7629dfa34a0863775b2a23a610e712af2bc74ca110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6fe83ade850cf416094cf7b182fc2dc2e55507ba078ab41dd207e7cdb87bdc"
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