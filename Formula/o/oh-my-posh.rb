class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.6.0.tar.gz"
  sha256 "8273f85f1a033bc7c7e0076858a9dc843cb90a799757d34de161baca69e92eb9"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9d0b544aacb9a497f63c602b29845e00ddb8cdfac84435d753b1751eaed1398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b3b0b98f514e6f516b4d6937a9ca5ccf829857030d30409ee50d277459b466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5960481745e9e5ffc591bb2606f4aeb645fd6354d0616f9a3f86e471f39ea70"
    sha256 cellar: :any_skip_relocation, sonoma:         "bca1c6129f5a6485c1a20c5a8fd5eda98504796c46fdd6813d8fd9fd1a11de94"
    sha256 cellar: :any_skip_relocation, ventura:        "52f902b28adb5edf38599133f71130cbf04a5981ebc34d689e637e20bfe0f16f"
    sha256 cellar: :any_skip_relocation, monterey:       "e0b5c8c6a44636cab444fc2b56556d18db608b32a5d19d2ade88075d9b582303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e369b3f972558e4eae7411c7dd996eac407c6461034ce3dfe0e098419fc7c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end