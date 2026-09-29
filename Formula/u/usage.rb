class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "7ff9edb65341a36866389fecba7a83852aeed97ca1e98e232c6aaa3b7375db45"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "801278ecb9e56e5e700348cab1698871cad7eb7f801a343867cec3c7950aa253"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fafaaf1b5fda7543a45781ef9c206589268efb73a8e3a4d6070c63afdc19f9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d68143e13449c7b5bf8e2fae9dfe2442acb7aafc9b6fa0aa5a6f380f5a3a1768"
    sha256 cellar: :any,                 arm64_linux:       "773893711abe24f9a3127a968b3fbf0da3f2bbfb4a3d6762a50df9c7d2b38f38"
    sha256 cellar: :any,                 x86_64_linux:      "bec55081a950b4af07d04467267946a36d6a5825258632578e79d1f89d39e0e7"
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