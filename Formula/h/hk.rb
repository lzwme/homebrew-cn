class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.5.1.tar.gz"
  sha256 "a4080e2233380b44b9a7b4a1334a8f6d2c602c37d09bb24d39b2db70837c10a0"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5388b819475365134c2b719a3e5372d320c89911f9e6b6085d5d768a2855d92f"
    sha256 cellar: :any,                 arm64_sonoma:  "de43469d68c5994677125b30ddf9fae7d545b3e1d80996b3ec92ac20ce9400e7"
    sha256 cellar: :any,                 arm64_ventura: "02a29fc377acc21058957ca46b96c65e4485e9dff90aa41d35efb02790f04e2c"
    sha256 cellar: :any,                 sonoma:        "c84d188d22f12c38ced9861847b5e454ae13402da8020f326d2a575ff13965a8"
    sha256 cellar: :any,                 ventura:       "5bac03aff75048326cc5e64a7e694529145680c13577dd5aee9359d5d79a6f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5382f98615da27e65f14708d87332d05e6bfbc86510aa4eee077d1b93f1ed9b7"
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