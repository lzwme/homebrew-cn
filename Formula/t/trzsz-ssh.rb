class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz  tsz ) support"
  homepage "https:trzsz.github.iossh"
  url "https:github.comtrzsztrzsz-ssharchiverefstagsv0.1.21.tar.gz"
  sha256 "598d749e50af298700bfaa416690383bb16b9fc3d15ec66951857323726e2124"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fc241d56341ccfab04805ebf53411421bf880cec78e1183a1a9145178f943b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b7034e0457fc755f00726e4919f6088548e12aa6c076b63f4515a1a4658c5cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f25067ead93df518dd607b40907b2197ef9c96d98aa6bbb9682cfe632792f94"
    sha256 cellar: :any_skip_relocation, sonoma:         "70618e84647032c512e2d7398a95589308787671a24d10c5f0d78eb4fafe4ee2"
    sha256 cellar: :any_skip_relocation, ventura:        "50f459b092d9a07cd37c00649d7abfb55f8a8ab7cf13de3448441bfd34d07d62"
    sha256 cellar: :any_skip_relocation, monterey:       "478dcf79558b757da67b0da9d03624c68712c37e282a74a76a198126f78ba35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc300fcbbc0fb0c6380fd357f1ecad3b0806da8ba921fa9bb542e8d7d918eb9"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"tssh"), ".cmdtssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}tssh --version")

    assert_match "invalid option", shell_output("#{bin}tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}tssh -L 123", 255)
  end
end