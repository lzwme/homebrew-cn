class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "118d36d3202df40adba5ee95091941bdc90d6240129e2f1037cd69983c52307c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beaff47c9b4d3e5b51a5ac6bbd2287f6e2c17a1203fcd5e8eac10bde35e54127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "025c9171312af9ec7984aee12e137e6abd231d165b5633856ef8cccb2ba67dbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0672834d062067cc34b10a21ae0487aed1afa96fbced3e35fd0709f8757174d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7881b5c6c3745dd1846e2e47e275139314b006ca5247716dc23d2970b431869d"
    sha256 cellar: :any_skip_relocation, ventura:        "1e44a99260530109d775a3e34ecae1dad7f31e92aa998fe5a5f6d756085b35f2"
    sha256 cellar: :any_skip_relocation, monterey:       "245bee060a438c1168c38f97c0039666c5c23d1296f3e5e9f9b94b7cbc2756f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5417abc662773f6292b27d437cf97dfb722bb1650137d7ca58478196ac531d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end