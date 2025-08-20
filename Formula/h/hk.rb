class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "e7cc42551ebb34c1009dbf6f69c1823157cff82568ce81a8733fb58f5ba45f06"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a271530235b6aea499b0582ad7c6aa5ef980fd44d002c6fea06b962eb5d9a86c"
    sha256 cellar: :any,                 arm64_sonoma:  "43a94f82638d3a8fad13cbc0d592f9bc44f8246930dcee6fe1c186c7a47a360d"
    sha256 cellar: :any,                 arm64_ventura: "1628002be95450c985b92f6e028ae251d432826f98c30cda60eac927695ac31c"
    sha256 cellar: :any,                 sonoma:        "2d9a9b7cc6495555e05bdb368997e12f3d8a67fb920734f818323853e9147290"
    sha256 cellar: :any,                 ventura:       "6ddef1e57674f4535752196698994a1b73b54f925e2ab47fbd115fab1974f496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5369555bcf46df15114fa70059e3d1476bef57846fdf5e212498e0378f155f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708cac1b0492c1707ad08185fac755bbb407fa6393c947e797a5fe5062725a7c"
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