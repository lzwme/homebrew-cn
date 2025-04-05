class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.7.0.tar.gz"
  sha256 "7e92695a18c29fd8f72bec89b33d851e5cef8ec0c3049def47025126b02713c2"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d68449a7652c810e5ead3e58f2c0300c5e3895c37c2a4a61fef43a4fcafeebc"
    sha256 cellar: :any,                 arm64_sonoma:  "10c008271aa789f7ffe811df034882d98e17a3158a158800c3c56eb8f23d384b"
    sha256 cellar: :any,                 arm64_ventura: "9e1772794561182f56058b73f3fab4a7b9f0b5b493326804997a10440fa17a8c"
    sha256 cellar: :any,                 sonoma:        "c3a61397fb38055dee16b5070ba59d6c159ba1b9fd22240a6058b5816e78b776"
    sha256 cellar: :any,                 ventura:       "33bb57054865c85dbe3646ff66daaf1dd9e1f9a7f46d16455b3e57572214857b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c576ee8a8d0eb8c4f995084eeb0cec6e630ec2c8b7f164b8178ac4091cdb7e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d9834d3e4953edfc4931ded84ac5dc92e4225bbc373a57a3fc635522bd6aa0"
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
      import "package:github.comjdxhkreleasesdownloadv#{version}hk@#{version}#builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = builtins.cargo_clippy }
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