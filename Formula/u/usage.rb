class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv2.0.5.tar.gz"
  sha256 "9eeca0e3e4ce104a1eeb7df7413cfb8a189c2910fe73efbddfdfeff056135e44"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fb8b204ce1dafaef353a1f876f336440374be4da500fccfd196e5bb5b7adb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acd218b50385a0a934de3e7197d4cf8c72802f23ce0c0ed8744999107dbc13fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8323a124179d89e2e68b4591f5d337940d7fcdb84b91492fa51e6be2c2ec0d99"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b14f3f2b8bb5cb97fb4ee76d0ede59356f300b1530219a0982bef0773375339"
    sha256 cellar: :any_skip_relocation, ventura:       "c4cc2804cb4de72cedab3d9bd413f9127a3fa279f9ec5b9a94de8a1792066dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e97b6fa70e0d5b9fca3dde88accd1eaf3da14f563c8cebfb1d22cecaf4e801"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end