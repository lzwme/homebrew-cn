class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.4.5.tar.gz"
  sha256 "e2a02db455cfdc7445ccc95b932eb1a62c32e9cdc643ee3010eed4d2b98c6f7c"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f846f67851461fe0da7a5c3a5557eb9565ed8ffbc3e1067f3370e8c57dffc8e7"
    sha256 cellar: :any,                 arm64_sonoma:  "c7980890aff713c0efef366f6d25178e8b79fde281ec3b518946cfabcafb9a75"
    sha256 cellar: :any,                 arm64_ventura: "47d27e833216a657ff8030dae790c67acfd4118e89db0254db91b48e12182085"
    sha256 cellar: :any,                 sonoma:        "cdcfd2583c60c9cfdbcb2bb4f30feaecfb58f8d66410ae1b7e7916bfc58e72f7"
    sha256 cellar: :any,                 ventura:       "fa8970909385086d8aa268d6c57a142dc3f6d220200548d5f634f3ca166b0278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdbffcf0824112cf041f38a6fd844d3ee1cb95df0525278898c90a1d71e29492"
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