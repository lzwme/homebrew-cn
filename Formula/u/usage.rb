class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "8bdc11ab0937325480df51c28d7528179e37efb25fa1f3283c6645c08b332cea"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6067b62140a5253c05028e9928d48ee2c10f4460fa0537f7cd396956f3212ea9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9489b619aa4aff00923f30ec8dca172bdf99c7c156ebb992b3cc00bcc4644ccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a00ac8fb2b358b45ca49b68db4961bedc8148db293e6f91406b7a943419bd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7e4a803cb776059090076f08462c2da350536dde5b6284bbe9713983158ae0"
    sha256 cellar: :any,                 arm64_linux:   "f253122b52996175867b2d38bb1060c3d213e47c9f213d21ea92e7652536adf8"
    sha256 cellar: :any,                 x86_64_linux:  "fa4f1615982e8175d33612aa4f430a495105fd1576339d06d97c8ebce5aa0e5b"
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