class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.10.1.tar.gz"
  sha256 "b90243f33afb574ac1bfc92ddfc21098f7f571a48ac275bc7db40c6111546b54"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dbd03d56011c40fbda2fd4ca630aa83ced8bdc61cdb34fc830789104ae53a25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15cd68f06996b8be06579a062550e656b5f72980b32963b55cae94399937a3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c08bdff214ef34c96519fe5b47c6a534f135a2ca9ad3e83d8c23d348e92c600"
    sha256 cellar: :any_skip_relocation, ventura:        "6788b0500aecf91cfa1f7f37eba403885d8ee7d9dc1c2ef24203a7842e9b4a70"
    sha256 cellar: :any_skip_relocation, monterey:       "29f937fda3dd856c2a1e2fda2cd0d4d759c930fb933808e2ecdcd9b3bce6bf33"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff8899fa2d5990dfddab44599e8d7d48b03d5d5a95bf5e4b20e8a15ef726ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea2e5622d004fcaeaacb8ba18b26d1c99a0fb599e90386085676c6b5940f36a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end