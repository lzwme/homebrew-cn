class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.6.0.tar.gz"
  sha256 "65c0716d9e6fd44a8bf436967ac2d378162d5478dfe072384d71da85df8683f3"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e854305a530add23f846ecc5b2329423e6ae920807dda9448e76ade12e1c3794"
    sha256 cellar: :any,                 arm64_sonoma:  "bfed20c1fc7ede756e317f645c23913147a5e5fd62a34b02da79a3298e536d37"
    sha256 cellar: :any,                 arm64_ventura: "38c538cc20ff913b3db1385067455f48de326fda1a109142e23bec6477e5901e"
    sha256 cellar: :any,                 sonoma:        "9a10feca3c209a776668596be1ca79120199d3163619bb040c0001a6bd2dd7f5"
    sha256 cellar: :any,                 ventura:       "fcfdbf6449c11d2fa65f5b0c39355d0433500e37d7b93c4aed772b494d651617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33394786e0abdabfd569bcf890df37a6ddbc47d86ea07aad1de0bfda065df9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2108938d73a52a551b7f0115f7a491f9dea3a9cf73cb2df3bf9082c9beb9b2c4"
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