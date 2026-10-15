class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "a6bc16eac79ac3e93b54d44b4129bae9197170fcdb705a47e14d7aa28f131db3"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58d407eadedcc89801218cccc201e636f94847839ae96549ce48f8f01f171ed6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96d8ae6d6deb7293c479c2510cebf6df5c9deb0ab03fa804cdd6cf053c56115b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b13ebff2787aef129fdec2c5813debf370a6c400b7b5607c827b5470b78cd9ab"
    sha256 cellar: :any,                 arm64_linux:       "0a4563943bb7ad8ece75a3d20dec54315ae9bd1608b827488297849a186bcf47"
    sha256 cellar: :any,                 x86_64_linux:      "4eabaa3cb3299effc8db1dae9f46fd5a7668e36b9da73e90e29c3f82d77e76d6"
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