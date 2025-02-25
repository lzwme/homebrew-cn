class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.4.6.tar.gz"
  sha256 "ffddb783930a70588dee391692a8207801e865e4248ef176d5d0699c57d75185"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e47ec5547a8061696bdfc508d016abcb679b5477ab231d3d1759424d4a29cd3"
    sha256 cellar: :any,                 arm64_sonoma:  "28fa971828f98aea5a26ca96af7e34ee09c64dd4261f9807efa84f6668197495"
    sha256 cellar: :any,                 arm64_ventura: "992590d09a1aaffe0587f73fe3956475ccfbb3a5a417ce4dadfdf62aff9e9454"
    sha256 cellar: :any,                 sonoma:        "db32d404a64825fa075c583dff61159975882fb39c391031a2df5cf9351a834b"
    sha256 cellar: :any,                 ventura:       "491629c3f0b39b141c56d42fb19af60e883ed237b7bafe292d4bb1593aa454c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b844e4f5c75feeeb78bae0ed12a1bc4ec35b896e3ceb8fe8bb742943063c2c"
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