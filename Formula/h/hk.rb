class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.37.0",
      revision: "e622c73575b527e3dc3d69989dea23a458cceddf"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc33d7df59875f83c16843df567844c594ee3314528c3e1f9bc33f855dc32488"
    sha256 cellar: :any,                 arm64_sequoia: "97bc0f1d3a9b8e3b4a3c0d1317a91667dcacbac6e9d677719d3dcd378c1a6972"
    sha256 cellar: :any,                 arm64_sonoma:  "332ac266a8a44f94989762c61474508b5866fee765486c659b9220b32f3edbc5"
    sha256 cellar: :any,                 sonoma:        "3e79a9570ad8d6608f3e72633fc6bc5f5b363ea22a0b24878700503df3189bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfa25a76a334bfe6ae8cd1e661dd4fd6450a82a398db49973466d68ad54d17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58fce10f796275e01a3afb6108d2d36299385407abb162d4092fa7c64923a7b7"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    # `mise run pkl:gen` - https://github.com/jdx/hk/blob/main/mise-tasks/pkl/gen
    system "python3", "scripts/gen_builtins.py"
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