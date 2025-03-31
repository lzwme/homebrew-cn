class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.6.5.tar.gz"
  sha256 "6313818ca222aef08c537ba2ef4a132f1087d689fb8aa020bbeab121f5fcdf92"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c744b7478798d02fc11a0ddbf9a28ceb93c24678aee7f8cf91f8ac320c36386"
    sha256 cellar: :any,                 arm64_sonoma:  "a4ece7f42141927216273df52445fe5eae2a48b354d56823289b604d562a9156"
    sha256 cellar: :any,                 arm64_ventura: "53e33fcd46117daa5a6fe3a209c39b95eedb36ee825865ef40302eb5d6795aeb"
    sha256 cellar: :any,                 sonoma:        "05b4685720eac78e58bd0b3798e36c0a7f4180ae81013e9e6a02ce2454a0526b"
    sha256 cellar: :any,                 ventura:       "c40634ba045a1e646bb8b21ab500cc289e40c75d3de55aaa173ec3dfb8a75b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3427e11e90269db1c5b17f35773c68f83ca7ed3537056581f3385f56084e79ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56760b789c9072679d563cc55c0342eb1583e254a1b46ab09555dba082bb8237"
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

    output = shell_output("#{bin}hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end