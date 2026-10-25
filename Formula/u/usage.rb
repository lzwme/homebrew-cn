class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "94eca918e69b09b3a9d68704a57520ba9651f320ffe75ce7ad04258d1302e5d0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8170f0370605923f9c29d77852ef99ccc36896be931baed202c4fdb70a834c01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bff3179a8bfc89f211cf36748f989ff3724c0d4f5b270038e5d3d4601d61373e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad764d6ff6349621b9abd61710d01ba475edfbec95de71053ba2a0947f925e96"
    sha256 cellar: :any,                 arm64_linux:       "397b34109e53b872999917b3232d4032718c73000be183d8f1b9e13279bd3d45"
    sha256 cellar: :any,                 x86_64_linux:      "a284c5314e3123fbb5268c0b8f9fab0a6a230b604ff3185dc68e7e5d49aacb8c"
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