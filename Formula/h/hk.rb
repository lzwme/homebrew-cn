class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.6.3.tar.gz"
  sha256 "a752194f5bdaef6e6ed43e76d4b9e6b09aec917b45714a0f5bb87616cc6d2112"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1bd25eac2ca394e610a4eb07383691e2fa263d06bcb21f270e1ded5e665d983e"
    sha256 cellar: :any,                 arm64_sonoma:  "05b80b4458e282c1f043f49cf30c75f48b975f22a07ed9bfb48a0f925ac70e69"
    sha256 cellar: :any,                 arm64_ventura: "cd315e269e3ba01f9f1452f6956944d4233c4d83e05180259679dab8f6e8a8b3"
    sha256 cellar: :any,                 sonoma:        "941ce57c17f15a891e13956315a6ecaa4d6b0041374821f167971759d24b9dcd"
    sha256 cellar: :any,                 ventura:       "6a1c1f6621f3a31e395939d5ba1fcd07682bae1773b047866f6c833a20f25c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08be643d62c6819c8178e0a0dd63b6134d1e2a282aabab81e7556b0c20a30ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2834189c1aa13a9b984d9a1401922c309dbd6db621d37e4b970e489aa7f9cd"
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
    assert_match(✔\s*cargo-clippy, output)
  end
end