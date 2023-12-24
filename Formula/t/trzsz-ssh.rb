class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz  tsz ) support"
  homepage "https:trzsz.github.iossh"
  url "https:github.comtrzsztrzsz-ssharchiverefstagsv0.1.16.tar.gz"
  sha256 "0ca324f7ffb7c5c1a696d1abf80b104bf669532d2d86d30e32761732f76c4592"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bedadc622334643d6e819c3b2aa38b8f8563c2e870b001d9ad9100c1bf90392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e134f0f92ab3cf0e379cde64458186c8ec09dca69032df5a797be087f403b0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84662afc0573d33e87c697aa7a53e0069d6ffda14f309f456f6f3ef1a2c0300f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4de4d61250b6ac5f5295da20410abb510df625dfcdc6424e164b431680c755c2"
    sha256 cellar: :any_skip_relocation, ventura:        "2222f4171076197f2ccbda7a5d440ad176bdee6b29a582db298d106e8194ae67"
    sha256 cellar: :any_skip_relocation, monterey:       "38c0d479e0d352d9928405b7dfd655915d6a0eb764d65d5324e5c0a825ffdba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2981c3e0c046b3eec30d97d56c83de2ecbc11c67e4a2e185642ad72b57c16ab9"
  end

  depends_on "go" => :build

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