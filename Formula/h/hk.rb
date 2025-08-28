class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "63e0879c4ece0540a4ef31b17b1b76929821247e28b76a325cb4a301d92f533c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4ca8b6e2c743002e14684ba6f4e7861266cfe1656bceb2a985f9932a9535c53"
    sha256 cellar: :any,                 arm64_sonoma:  "b415ded2107d0a4fd26f11764b4790ad5182c3a3cc3c5bbb98ba68180a9cbfc8"
    sha256 cellar: :any,                 arm64_ventura: "7cdebf7f4cf04417552162490d85f4b096c0a6dd4cd12234fac5a408cb61f736"
    sha256 cellar: :any,                 sonoma:        "ce9e83c82a25fe70f6c3974afffc3be61c9b7acd5ef3aface45b7bfd78ca8cec"
    sha256 cellar: :any,                 ventura:       "05c7e65899e067e3560e23e70f28047c0e1be382d3627ff3b0e8a1735f2b1e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aec728b5819e01e81e59fbcabe4cd02a786ec364847f0edfb8c5bd42a43d86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86976d1e69b599f8495abd2cb2d5245b8e4335677e48e1587a63ddf9a0531a31"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  resource "clx" do
    url "https://ghfast.top/https://github.com/jdx/clx/archive/refs/tags/v0.2.19.tar.gz"
    sha256 "b06f39d4f74fb93a4be89152ee87a3c04a25abb1b623466c6b817427a8502a73"
  end

  resource "ensembler" do
    url "https://ghfast.top/https://github.com/jdx/ensembler/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "967f98f6dfd19b19e0aa91808ea5b81902d3cd6da254d0fdf10ffbaa756e22bb"
  end

  resource "xx" do
    url "https://ghfast.top/https://github.com/jdx/xx/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "cccdca5c03d0155d758650e4e039996e72e93cc1892c0f93597bb70f504d79f0"
  end

  def install
    %w[clx ensembler xx].each do |res|
      (buildpath/res).install resource(res)
    end

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