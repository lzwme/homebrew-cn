class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.35.0",
      revision: "062a142b92dd5be5f6f71c47c2d5bbf49fd5c695"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9acc977c552b6d954851e233bea39d118a8e6f49e376e96da4c7cb16aac842dc"
    sha256 cellar: :any,                 arm64_sequoia: "4af457637ea10b85f7b1106edc93b341ce283d1b8e8fe5ed4b1b43796b7b481c"
    sha256 cellar: :any,                 arm64_sonoma:  "e93c80e851e027d180ec9316a9fc710246a687897ff2de7b92a2ac8f944d4133"
    sha256 cellar: :any,                 sonoma:        "747f4dc92254aa551a2877d67eb0f17721db6a42600c9420210def94574c1125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b48541cf2f006f99ebb5f977efc2bd27a286a8979cf263ca7a2bd0d559dfbe62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36477c863c190faa8260a90319facca1e8454377a217efaf30d346f579b9284e"
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