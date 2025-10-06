class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.18.1",
      revision: "8deb625a8e11e9a4f795b3a3f186084043ba436e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ba2d395347ee23eccda468061f5b87c0ac1951d09d64037c39c907c92322f15"
    sha256 cellar: :any,                 arm64_sequoia: "235c977ee3a0b677f1ad84f1882d0b1479007e515a4344d60e515aa39bc4cadc"
    sha256 cellar: :any,                 arm64_sonoma:  "b52f628616d81700b7fecaa0c445ea865f82f493eafdbca8dd64e38d00afb797"
    sha256 cellar: :any,                 sonoma:        "67317d9c9223cf941eb9354e09788b711ce5c68819a7aea389012cc36082c978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73b8f90c7861e44d297178a7616fc4364005f6171956ee401a0ef183a63799f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d08e01c8c18f3c1735fb8f2499c2f815682eee0bdb74ac9623d4339ad68c79e"
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

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end