class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "29d4840b364c7b7c0e893f722da866e362d85e45b846616b57dfb60c983dbe7c"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c822bca88de16719bb68f33ed89badf58acb1bb13291eedc4fa90b30143620b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661834773a28282f17722478b6b49aff2adeffe38e3d82bc7706ca78c855b658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f26427bc5df491e74f239f549483480dfcedf8cefc9238082a3e2c94147e175"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e71d9185b01bd6d82eedf3c9b0f165f11b3cb8415385fc060021f6e7878dc55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e5db902829c25b7d4c3a0afdde1da1caa9b48b04169423c201a159c41107c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46654e6697c3bdf4992b5b74efa2384e2c6acb60f2d5a5970952285e37bda67a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end