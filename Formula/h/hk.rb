class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.44.3",
      revision: "bfaec1bb5c778f2e2e8867ca2788f7b2fc804197"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d35c1123b89fe42d372cd80d4e33a4c182da892b263477524fcc13a23d3a6c3"
    sha256 cellar: :any,                 arm64_sequoia: "335a5d0a573c64df2efd894342c28ffe3b15386431b0e632d1d85069c2f46251"
    sha256 cellar: :any,                 arm64_sonoma:  "e25fd3d400ea51096f81c01bb9aea734de3a13beb9a290f7e5fd21cffa375d6a"
    sha256 cellar: :any,                 sonoma:        "7db7848e374677e71e1b1b30c54a841f08f5ad940872045c6595d80bedccb029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8d0ccb67b9b55c137c06d2224843a894a21391d9e7c29555da9c5bd8cb6a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e71174accd94e4910ccf40ee819000da5856983fc1a88457311199d5f4b11597"
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

    system "cargo", "init", "homebrew", "--name=brew"

    cd "homebrew" do
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"

      system "git", "add", "--all"
      system "git", "commit", "-m", "Initial commit"

      output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
      assert_match "cargo-clippy", output
    end
  end
end