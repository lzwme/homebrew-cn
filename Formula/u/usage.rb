class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.12.1.tar.gz"
  sha256 "1666a64f07a7937f62fc47eaf0e06d4e79c24eb2e965843237554fe43b719ca3"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85b1b7c0acad11ebc7bc5dc105bea2434310dfda440e996c0a13274e198160d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1145fe765675391c2fc66eb651ee837304c60cc01fad9ae3d52ba3d348b1005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7a671d16ece097896098c86358ad9faa642df0e11935fcb73e29cdbddc918fc"
    sha256 cellar: :any,                 arm64_linux:       "d645640430361449081b5ebf20a6b7c82cebad6361c2277bbb1d8f66d9306e9b"
    sha256 cellar: :any,                 x86_64_linux:      "560d25761b24e13c4c23659e9a19609d4db53adab6ddcc7c2c95d74bb9ac0bc4"
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