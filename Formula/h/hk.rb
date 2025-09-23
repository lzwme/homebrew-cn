class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "3292f6e9eedf1407f02e3bf6f6a37bf6f57f89210ab48bc867b309ed7280b3bf"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9da015f1b3337a900e55d415ecd0e1b7a389845411637bda37cbf00c01c0cad3"
    sha256 cellar: :any,                 arm64_sequoia: "36beea1f213328813c8ab71c9869cd334266217eb196065f2f07fb5d5185ffe4"
    sha256 cellar: :any,                 arm64_sonoma:  "41a63d295961fd948f57a2dd966689d69c2b2afcdbdf51974118c7bcf68318a4"
    sha256 cellar: :any,                 sonoma:        "487c553f6559926b2c6fd3b82dab47d0f79227deabc21cfa490cb339d3da2eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b79b14e2c9769f5bff4ee9080d512f70c3c062235b973400eebdc52b433c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ec10211f5e1c2cad61e7163bdc465dfca0754fd77cd1bf260136209eb49090"
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