class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.18.2",
      revision: "71592cf74bf82927783a985a5a014a933dafcbfc"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e7f494a60972e947baacee1f033e9c3065d83908a478fbe9735a45dd8184212"
    sha256 cellar: :any,                 arm64_sequoia: "82ce1626dd3436821aebd15502c65ac2f69494750df7260054b7d2ef0b016923"
    sha256 cellar: :any,                 arm64_sonoma:  "1ed43c3357d0e1c6ef64c0653d2194407abe8c0f4eee8fe551528463840e6328"
    sha256 cellar: :any,                 sonoma:        "bb0cb062fbf710530786ac3051ed54fac8c8a680ebb5e02083dec20313521e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf4bdfa2764f2263d61117384a824b18bb9dda8b5180e7e9c62abf5f3c063cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531e2b6ddd2c7460b9be22071938b309ab26e377b25027c8783fee4e6a14e281"
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