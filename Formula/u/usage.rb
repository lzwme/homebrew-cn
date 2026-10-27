class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v7.1.3.tar.gz"
  sha256 "d2c619df2505182be19b45b3c9b983858209c5e9d9353538c46ab39a34a1ff04"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "874609cbaedc68e59e48fd7dc421aa553bd28a11ea7381c989ec719f58ff7d11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4388138851487559aac58f272467a055b368c59d1dfc469be3ae6183270d9e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca9e59c8041e4a32a6e44186faece5b609c4b6445352e2191321f9b20a55f450"
    sha256 cellar: :any,                 arm64_linux:       "af80c7e260d38ee5f1b2c69f0f72bc94ba93430358be98dfadf03ab1529cce9e"
    sha256 cellar: :any,                 x86_64_linux:      "e0c0c8d549a70a48c34fda72fe0ea52992e348b577c19d1996843a2eb202dfc8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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