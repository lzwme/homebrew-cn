class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "ac903db2d2c0fcee17a285da60fcc292b90a2f51ff813121f73cf050c023daa1"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "050417cd738caebce21aab1493cadeb1654c4b8efd54d4965920310644cb5b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25fa9a240218a1f326ef6520f8fb76f1355f244f720fc8a5f49a5b0b32b4eb46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e35b8423f9354da6f3e2195579ae7eb7e4464d20f74bf4fd826eeb35528d4836"
    sha256 cellar: :any_skip_relocation, sonoma:        "15963f1d7fb3cbd6a5bd3176bbb19d9132c59e1848b13c4c4f9fa39a88ddf16b"
    sha256 cellar: :any,                 arm64_linux:   "fef951c80ba631ac84f0b7c8f5a3a1e29ed0ca78dfb4a04c3e74f1e581e99000"
    sha256 cellar: :any,                 x86_64_linux:  "da09c0920c59e74924573426feede9ac475156f93f4dc3ef4d466989b179d911"
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