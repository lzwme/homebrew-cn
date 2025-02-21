class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.4.1.tar.gz"
  sha256 "dd36dd2c2cfb4131d7329df47f68b8c6eaf8695dcac4d84e71c9dfe69d0a39a5"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "faf64fd6927145fcc6fbc3979a4778695beb1555df7aa7969d85151a59c0798b"
    sha256 cellar: :any,                 arm64_sonoma:  "7bc03b199daffcf1f1faa641741b42b0c16e6cf0ed16521322b35cd91e1631e3"
    sha256 cellar: :any,                 arm64_ventura: "d85e835badbd6180d9ef70dfbb6d45acef2d94ad45d6dfb36077ee03ac273ab6"
    sha256 cellar: :any,                 sonoma:        "87ab6176cb39f90330dd731aa33354e85611ff25022d22cec3a8df48d45f2476"
    sha256 cellar: :any,                 ventura:       "f6dda7fb6c861d5be01687b42b6fa6f0f8c4d2e04346807f3c623b6e7cb44077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc44c8255c45b165ceaa794c9dc9b324596b3b600f62bec772ca67ad6c40c2b"
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

      linters {
          ["cargo-clippy"] {
              glob = new { "*.rs" }
              check = "cargo clippy -- -D warnings"
              fix = "cargo clippy --fix --allow-dirty"
          }
          ["cargo-fmt"] {
              glob = new { "*.rs" }
              check = "cargo fmt -- --check"
              fix = "cargo fmt"
          }
      }

      hooks {
          ["pre-commit"] {
              ["cargo-clippy"] = new Fix {}
              ["cargo-fmt"] = new Fix {}
          }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all -v 2>&1")
    assert_match(cargo-fmt\s* ✓ done, output)
  end
end