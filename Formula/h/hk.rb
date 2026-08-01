class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.54.0",
      revision: "75a084aafb00e5bc457a4e3a1305e7e67b892405"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bd011f3a79b9b14a5b83c08ee65d041d636000388c64d47326023be3d3c19d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826feacc629ed93ac44970cc33ff6dbcae844b2f346ea23140ddc211e4c657c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "081579c71902094cf45b1452015fc83311deb21512813c99c400cdcad2249d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "771567b98ef5025755e1779074164da298a15f0e2107001eb17eaac65d443c2b"
    sha256 cellar: :any,                 arm64_linux:   "e9c9720eb986f61110e3f8c974333d808d87e304ab48099d9e5c48816ea157b2"
    sha256 cellar: :any,                 x86_64_linux:  "fcbf6b1394585539ae5b4bccbf8b052c66df0d954b20ee8ece810a70a0a9e61d"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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