class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "552e0530db508ca0c577070162c32a6e9512233f7306084580dfaef130cd01a1"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b61e91fb99c265e634b5503a03b1e669b3a5661e74e1d0e68b9822eecb38a8db"
    sha256 cellar: :any,                 arm64_sonoma:  "ec91e2c93382cca7b15feaaf3f6c170af96b0335904d5d4e675543f0b929e2be"
    sha256 cellar: :any,                 arm64_ventura: "273258eee6ba2715b12292b18e9bbff79967bc4abdb2a982c1f94d7ba381c145"
    sha256 cellar: :any,                 sonoma:        "82d6d82d255b338cef154b4ac617466d27f1e9dd8db57f9c6ceaef41ed06a74a"
    sha256 cellar: :any,                 ventura:       "afe4616959c86e6148cc23ab9d1f74e6dd0512a8b1bda2ce99291344a2356dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e44c7d97cca26f6b18ae1e9cf47f593bbaa9ccbf197d5ec059a161dd37d14a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f26c096079b96ccf20b6c34a6ef475915059b783d721ed9285bf5a54f6db19"
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