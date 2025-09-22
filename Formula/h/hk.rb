class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "15397d45eb93e9a5d5f4a4ba06b06c7d10ec2eba37c44b7a7ba47c3d4e164b0f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fae115a2f04d5a4d8406e54c766759d4ff952250cbbe722b4d09db697f4efbae"
    sha256 cellar: :any,                 arm64_sequoia: "01b84c42d13743dfc85b34d96cf62be026e6e2445aceeef7687de4911f7ca945"
    sha256 cellar: :any,                 arm64_sonoma:  "1a8184aeac67a7209a873f4ed7a41fb474f43cd661c477514db92ed569e894f1"
    sha256 cellar: :any,                 sonoma:        "2b196489b64c570bd5fc3a0968f0b37124a65d0c5527a9aaf9a975740b0ad418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8440236d44ce174d064b7ff1a39c33f30ae9c9fd121e17ec6cc0adacff633c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d3c794fc23a45e50cc8a0ee82d89d902855446cc5d7856af7f9c52a353e03d"
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
    url "https://ghfast.top/https://github.com/jdx/xx/archive/refs/tags/v2.1.3.tar.gz"
    sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
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