class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8921952478b496e8f615e75efa86fe8343e2d44538d4cfcb24ac06f499beab19"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ceebad3612accc1ed20755a2e4a7d1b408c22132d88fcb2dac8f0f30275106a"
    sha256 cellar: :any,                 arm64_sequoia: "c32dc570623a8e954180fc4944749a44ba151a79a3deccaf4a047b8c83ce8245"
    sha256 cellar: :any,                 arm64_sonoma:  "3c0f27d81dffe8c63c01d4f6367620069007ddf6ee02595b8e09bfea9bc079c3"
    sha256 cellar: :any,                 sonoma:        "452031b5236aa5d171b2d7ce974de2e5d78b90134072d72a1b83573757406fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7de6ac2732eb4bc1d0b24cd8528d62d0c6e1ba63bc094012f64d654f8779fa52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6344df1e600ce59c37d5dcc33219c00665d14eac6a68c8b5ab24b77e6b68038c"
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