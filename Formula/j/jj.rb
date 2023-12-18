class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.12.0.tar.gz"
  sha256 "da90259cd1003d9f87af277c8b20625f3b07c3fe785fb490fe17659f2082852f"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c66dfd7cab6c8757ffada9710fcf174157098750567144b03045a5dcba551401"
    sha256 cellar: :any,                 arm64_ventura:  "de20e3e80363427b2170dd2443499a11e0aa9e9e18d1e559270733c2613d4067"
    sha256 cellar: :any,                 arm64_monterey: "849c709f767c03b2e39aa9111928a7649ed5cc47d93600cfae192e54adc42413"
    sha256 cellar: :any,                 sonoma:         "4bce025a82375732240bd62f563d7bc0949b42b16c434f2e886f5f795c8b846c"
    sha256 cellar: :any,                 ventura:        "0e40ca5051a0f8ef7c82f8af67b86f2b69ff518cc8c2c981091a0aa89476b104"
    sha256 cellar: :any,                 monterey:       "ae286fe0f6d1b6a8b4ef8fa073fa98dbe7aaefef0e666ec43b5e62e7043d6204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2586971247b5580729ae4003c22c95882b808425dcfbb4d84a3f93c2f85f9f1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin"jj", "util", "completion", shell_parameter_format: :flag)
    (man1"jj.1").write Utils.safe_popen_read(bin"jj", "util", "mangen")
  end

  test do
    system bin"jj", "init", "--git"
    assert_predicate testpath".jj", :exist?
  end
end