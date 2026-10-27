class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.9.0",
      revision: "29ecc437c6e1007b2b59ec4967b2333ae158db34"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f60104d7481c115f67e4c28eac5101614ad026e8827985bc7e4191341faa4d9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b5ac4608e447e724959cb1df7df5145e50d7189d223bd0386b5b4c3431469dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8c593e2a0840a984a91ce542ea30c6feb4593cbac3c600363754ed8d677fd1b"
    sha256 cellar: :any,                 arm64_linux:       "360dfd1fce503e2eae3cc2a2cbd936abeb4a3ebcc1608c82ee98f427649b1dd7"
    sha256 cellar: :any,                 x86_64_linux:      "0462b85d69b6ad8298de411c97715c86c7659654bf5556f7bf7ff1c466a18c9c"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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