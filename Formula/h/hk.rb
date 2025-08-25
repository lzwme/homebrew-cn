class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "9548c40c38feca29e5a76af0598aa3aff9fe3e6fc39f2dfdfb8462cf5ca87442"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "761ffba793fda0240bd263604a9ca6d8cdd8026b5118c9a222902e64d9ce7595"
    sha256 cellar: :any,                 arm64_sonoma:  "7e14d220c439e362ab2976c12c68929f4768a1d1eb4ba59d042f48848badabde"
    sha256 cellar: :any,                 arm64_ventura: "152f0f7f63768b8d7a93647b9167d9fc02a756af7776b74c7f842baccbe714ab"
    sha256 cellar: :any,                 sonoma:        "5903e4a81e2e2de05a751ff78a5458086392c54d28aeb37c475ed72d2d197fca"
    sha256 cellar: :any,                 ventura:       "4748033b2e0e8450d8c9441168b8c13b760cbbf4cd5218f0f02bc11704ee0e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df7f24eed4837da0a21b59848233c93ff20470d760ef5302b6f328d8c6fa791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea57916609b1d93defbad612b8b0ad86f40760de58f45d3d292bdbd7a8b039d"
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