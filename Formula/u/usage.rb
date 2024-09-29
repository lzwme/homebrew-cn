class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.8.3.tar.gz"
  sha256 "5188e1f31df3f284da429231e028b43ddcb80c971e1804a1c85adb35eaa481cb"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b0b24807cab1150a85196d429881afb33507584be720bee7f4afc6ececf48a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c71f660aab89ee575879b1e3dfc9dcb8440f06221b6de1f37ab9f8fbcc26b4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "198d5a9a63e334a1b77d2b759c0d28c9500086803a635786b7203b56cd79c984"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab917ae54c23d3dcd92546eddf07c06d38b354ba726ec237751548dab723517"
    sha256 cellar: :any_skip_relocation, ventura:       "e0ceff513b45e02e0860b2c9ae5df57a1d20700ffcfd27a8b5309f71a4022ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b283b2819b1376fb3b7e204b547f211d13f8fb66150ab3a60c21073ca38138e"
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