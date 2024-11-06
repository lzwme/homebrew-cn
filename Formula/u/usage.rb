class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.2.0.tar.gz"
  sha256 "bbed16f8e6b0ba92f2281317d23f644417dc3e116861943c6c72812bb831c451"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86b97c5194bdab19ba8986b46d872e5c3962bb72f1540fe5d6fe143a85e7e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609760446b41007fd0287e836d24abc6d813e8de91bdbb859bfab0b0f5796666"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dc5af1e997406d68b646d2a33918788e0af9dd239fbfb75164bcaf94bb7faf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f50b4babc5bb256fde5e69bff93df811379bf326dd98bd06e10113cca76a03"
    sha256 cellar: :any_skip_relocation, ventura:       "df073901def8a84e44778a4d4aaf4b1e91bb276bc5835e0ffb0ee3dffe7f3b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0b604ed6e71aad52514a0782e05de890f2c5b7a2c50d0f1ef479597df75595"
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