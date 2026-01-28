class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.34.0",
      revision: "1c3a79f32004944d2147495c09256a184a1eb0de"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "552ee29a356c445e1ee5ca420d7036f88bf34aeb5142c786d80ab6cd7887b90a"
    sha256 cellar: :any,                 arm64_sequoia: "fb011a33e0ae05fcdc6e601df28afd1ba3a51e267ca793c3bb2ac0dd3478ce5b"
    sha256 cellar: :any,                 arm64_sonoma:  "d4f761fa97681d0c55d978a37deb6076716975a19918cf727dae4417c9f1d4bf"
    sha256 cellar: :any,                 sonoma:        "60b7f32376c627503c6fa356b1d141eeb7092c09bb6f22fb2497b5f277f093d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ccb92df265c4cd383def6d9376a27eb26ebf978fab21de6fc08d9d029157551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a7035a7beafd6c61203098fdfa14dc100b5ec9ae284d22f870365d5007c11a"
  end

  depends_on "mise" => :build
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