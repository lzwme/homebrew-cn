class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.9.0.tar.gz"
  sha256 "bcb44d7e5411efd3182f7cdcc196463f9834d1106eb6fe32556595e670c456e7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "faa14a0b779b6a4f04e822e058026c9946ba54cea2da2e0ca81afda81aadddb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "650a815e1187db2081e2e3672302829b6d869df4b95d4f2f13f8f9aa08d0f913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26bd58501d00d5c3659a3893816dea6c4109e6c008d5be8c026199163ef474be"
    sha256 cellar: :any,                 arm64_linux:       "3d32f2ed4b73f3f552286785f42a732ebbe922e7486cf9489f86bce32596c3d1"
    sha256 cellar: :any,                 x86_64_linux:      "cbebed4260c4b844977ee476b4a9d0c9d92419916d60148bca34343e27ce1616"
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