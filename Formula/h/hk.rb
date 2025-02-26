class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.5.0.tar.gz"
  sha256 "10a7c78a85b8ee5907e1650a77f508c9dd4c897af1950c9cad164ba2ab2f83bb"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "787fdf5d35ada68c1ca95999acd25e5abaf0200ceee2d75875a17078df124691"
    sha256 cellar: :any,                 arm64_sonoma:  "7401c0565f3ac1738abe92da90778b037b0daed67f1e24b002fcd2e16652dae4"
    sha256 cellar: :any,                 arm64_ventura: "d503cb4e6cbfa37c214760c0ded56be243df6ad0e941f34210fed6d4871fc180"
    sha256 cellar: :any,                 sonoma:        "6ae41cba83228cc3aab27190e103db28830bd3f2718558ace1ebe013545328f6"
    sha256 cellar: :any,                 ventura:       "692ffdc440708ecc66403de9313b006429d9aa4e0ea8946bae33eed7ff1769ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e742ea55e0038e8dd7a5a0647c153ff11be2a9bcfed03ffcdfe754c994535aad"
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