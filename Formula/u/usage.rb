class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "5bcc711ab2e6d3914888dfc7b07ae16bb796e83e7e0fc874804dd01f70f8e76d"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c7aed70d5e3e99ce958d355ed9b6b4800125e875e43fedc472519574e3956ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603a8118b421ae32a8faafc60aac97d0f6af9bb4d0cc62a31c8e857cf7b52d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5bcbc763b3a91f60be417a647bd43a3646bbb02a1a4527f25c958fd60010d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "34a85f4297b0de61d9c904a2ae15837c087de50dd9d29d3448da0576c518f401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e35dc4d85bca253738bd219616e96421aecc3b697e80137f6c9df634dd4154ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73eba30c8418302d9ddb6400ba09c68827838aefa8f0001d4b604675889a129"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end