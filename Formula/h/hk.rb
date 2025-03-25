class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.6.2.tar.gz"
  sha256 "e9135433179e2092e7c87e9169abced58a8de305c97bd45effcd4b95dcb344ce"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f660ddc9e21febecfe669f33eb413c835bdc958705718bdbb7a16b4ea3704973"
    sha256 cellar: :any,                 arm64_sonoma:  "29578b015cc506199c7eb44e649cbc432d9d1b4d3a6c04174fbe0c630221e697"
    sha256 cellar: :any,                 arm64_ventura: "8e65704b45a992e8b4f4d81488b43693402f6d7224b90b479e0d8387300daffc"
    sha256 cellar: :any,                 sonoma:        "c6c1506ab8cf2b956dd1f23d8a17e1fb13ece80b6fd0dc057e50668e652f184a"
    sha256 cellar: :any,                 ventura:       "be6c7dca48dcd0e8e6a1189ec4618f54243c50e6ad91324664db67b4fb1da2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c84be01f18c05b9626d3188b5713ec92237e16bbab62e75d427e151ef5b4757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5290abbe05254817203e5ffb814a23e2650725def362a169cedaca4a9b4496db"
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