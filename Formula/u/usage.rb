class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.11.1.tar.gz"
  sha256 "bd5d88d0733e117b3ea64c1e919d652a9608015f973386bd4d48de7cab46620e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4cfd8088be956be1e312f40409fcc4fb9cab715d0e01f1bf7ec504e8dd331b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5a4be77d32fac850052041fef2424509d72ee2887c2e660f763214e191f34e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b15866507b57ce027513bdb9c2fe93e675ae93beea327aaa6be1085116d70c33"
    sha256 cellar: :any,                 arm64_linux:       "af3da41a22437bcf005e0042cc5270e813a00e7de1f259d06755e1be9f407250"
    sha256 cellar: :any,                 x86_64_linux:      "6b26598d6b9b641007b014772cf31a1409a63f513dbec06e7a801625d53879b3"
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