class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.26.0",
      revision: "3dc8b55279e41dcb8517ba6e5daef7cee50ba7d1"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "126830657c2a9690663e2d9aebfb2cbbeceb338a4ff7ea526081efa64bf14f85"
    sha256 cellar: :any,                 arm64_sequoia: "e420e34fe7b4c2a68a88aeaa7e1b186995fc3db795306ee94d03bfc06df6fbb6"
    sha256 cellar: :any,                 arm64_sonoma:  "3663d01ee87b1679370c336cf0c729ad506fc18638a092758360a4dfdd19e3f4"
    sha256 cellar: :any,                 sonoma:        "1be0e4ffb13cb95c03ce0847498338a406413045fa622956b6114a0afdb3a49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6221077c7638a0ce7395284c603d1855213cf31108a0ec266752a4cd50e84f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32113af46251592ffa0df1be17e1d7131ad08bce84a2d41bd84c84fa983db2ef"
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