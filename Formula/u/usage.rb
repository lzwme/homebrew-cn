class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "7a497928257809b325e7da1d7b1497931385999dec1f7bd1c695f9218783515d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869e05b17fafd629ae7ab4247671f212c83ab22d7819ab680f8039adbaf1ab3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079f3eb202bcac08e05cc32a132570d56a4cbeb092f298b6042ae617e35cc925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac4ea75a6a73a86a569154f43185bed4af4d60bf1d9224396c11cbd7a11af2d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "28aadb91d9695c453c2312eb54cbb36c1ffb55ff78bd92e68879d0d8341528e8"
    sha256 cellar: :any,                 arm64_linux:   "2d7e7abf580969ad647ccb3716e7fe0e07d29c9bb67dc29b8e2b555c3fb77d05"
    sha256 cellar: :any,                 x86_64_linux:  "6c887085ba476d24d3fbbd2cedb6b5c3f476fe3cb4694503c9f06e00026db3f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end