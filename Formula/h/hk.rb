class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.6.1.tar.gz"
  sha256 "95d60d6c97ed37618f51eee7891f60c3fbda47645a9244d8d6aeffa1ac578b25"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aedba5e7fd3fc6a617d1224f35b406b85dfeb23f38b530c6dabcbe61b02fa361"
    sha256 cellar: :any,                 arm64_sonoma:  "58402d2fa775c81e61e53e2eda20ff2d7011084fa7f0b3b1e494e68f48f5c870"
    sha256 cellar: :any,                 arm64_ventura: "330a0df96ae33f7043124443fb3e706f5f39dc5803f0cd8671bbe2558fed99da"
    sha256 cellar: :any,                 sonoma:        "a08e8dcd0b98b982d90a036b6c5edc3adf6e05631ed9280c54e95587f7598ec3"
    sha256 cellar: :any,                 ventura:       "479ff1ec13cf7dd6edf74120c57a4f06df5f5af9ce9d4b59012cd1bc56a408b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2efc2be806718ea3cb05b60d78f335c1b72f4b9cb96b5798deaf84c2590108bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6bcc8e2b323304be3bdc96644539a17e31a648e59402b44cc6c797c59df196"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hk --version")

    (testpath"hk.pkl").write <<~PKL
      amends "package:github.comjdxhkreleasesdownloadv#{version}hk@#{version}#Config.pkl"
      import "package:github.comjdxhkreleasesdownloadv#{version}hk@#{version}#builtinscargo_clippy.pkl"

      linters {
        ["cargo-clippy"] = new cargo_clippy.CargoClippy {}
      }

      hooks {
        ["pre-commit"] {
          ["fix"] = new Fix {}
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all -v 2>&1")
    assert_match(cargo-clippy\s* ✓, output)
  end
end