class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.4.4.tar.gz"
  sha256 "3a067511d78203e86d02a820411fa496e8ada2f2caf5f6232f5035152d6d35c5"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "629d44fb084b4757f309129c8ec2ecc20d8daf6336278fd2a2c9df88c6774e0e"
    sha256 cellar: :any,                 arm64_sonoma:  "524c910869c793dcc5f75f1b457414e6f3b7874bc201b2e543b45149064ab66b"
    sha256 cellar: :any,                 arm64_ventura: "e7361c72b30691af24fe3c702da4e921169f9867eca30bed7b84be6bc175a023"
    sha256 cellar: :any,                 sonoma:        "95cf9228def240a4394e15a40fb8b069b6494e414a0cfd7003900413beaf0739"
    sha256 cellar: :any,                 ventura:       "67c4ce913148e7c8f61a0a05409a8100fc1ad716bd404353c08230f080887f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b0158141e505f0c115a39fe038c8030fede291a23f80147f72c316c351ad32"
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
    assert_match(cargo-clippy\s* ✓ done, output)
  end
end