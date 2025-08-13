class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "050c063753b3de24ee8b6e0511e035c3be9ae94c0a267610c05a255c0fd742f5"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "345ba62684301875475d94ab145420d44a92a33246b42187af9b3964ec52aca7"
    sha256 cellar: :any,                 arm64_sonoma:  "cff1c3496241addbe83375387af88bf540867494b5749c394853c16762c9d601"
    sha256 cellar: :any,                 arm64_ventura: "5241711fe001493a74a5494027b87d484aa73ac5e27dfbdb82133eb0e2fa8f32"
    sha256 cellar: :any,                 sonoma:        "6a526ca98827ebdbfca696a8500ce6091090f9eabe4dfb3eafb9f302e926f4ed"
    sha256 cellar: :any,                 ventura:       "ca097b578644ba40bd4894de6ab9c01a2f34866a65df7b89f7e277d02b86e388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f4c2ad5854eca037f7360353f5812024929e77d9515e0cf64332d552843448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca04f07006c37a3b670053837b2ef2c16032915e26bedede383688050fc83585"
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
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end