class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.15.6",
      revision: "d5b0139c7f4c0a3ba438c0fbba98c6dafa2b297e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0d87380631be7bd162edf5de1ac46979f0d7bbe3564acff0cc1ece0674c9923"
    sha256 cellar: :any,                 arm64_sequoia: "88ab522a71a1ff38e41f6b5d60dd1b848f994b19850545f6d7eebc1affde02f8"
    sha256 cellar: :any,                 arm64_sonoma:  "3476d059fc1d31195b3054fc17bbf1a79c561c9cd8a7fac7b236f1d3b520f3f8"
    sha256 cellar: :any,                 sonoma:        "05b014a03936f34b25498fd7d76b40275e1f3c1a21db6c1e93a088aee525f9eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6e323165f6071f7ebec1dec501280168019751cfb8ff55a07108678f4f5d58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a010ca57ce9a209e85eecda0961cbaa622440211350a7908297eac55d42fdf"
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