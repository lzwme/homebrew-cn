class Pget < Formula
  desc "File download client"
  homepage "https:github.comCode-Hexpget"
  url "https:github.comCode-Hexpgetarchiverefstagsv0.2.1.tar.gz"
  sha256 "fa7646bec975dd3995fb45d6b1f190565d6c4fae03c46c4eda34716c83ede03e"
  license "MIT"
  head "https:github.comCode-Hexpget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48b2b055afe66da789fc85f5f613bb9ea1af341f799c5ef540e9bfa889fad9ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e12737e48d675f8246fad2a72a0f79504d141de7eec04fc9f9490344770f542e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d05a59354813de8e38ff2c01ecfeeb6baa7b27553bc4cae67c6480e6b6bcd8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88ab2a98f522495d6d8f6d84ff4fafeb4ec6cd78abee41a757f73ce02f2ca378"
    sha256 cellar: :any_skip_relocation, sonoma:         "0acfc3036de4f6d29e1a6cc004aa1b452dae41249adb8e60b85b5578bdf32310"
    sha256 cellar: :any_skip_relocation, ventura:        "edb9edc985e7d466dcaaacdfdb31221c7109b2604777df7e9829aa4f0185dc25"
    sha256 cellar: :any_skip_relocation, monterey:       "0006e845fe431ee1e419028938963cb7a5258ded5d5b18c10a0670260bd6b86e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cc06f23fbd3eb30d66a1e8c6d00b63225d864d7221f4775b0679a277a05ea56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6edaa4e8d20796136fa7f95f21390d4827e88b4f596b04756489cde00260fa6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdpget"
  end

  test do
    file = "https:raw.githubusercontent.comHomebrewhomebrew-coremasterREADME.md"
    system bin"pget", "-p", "4", file
    assert_predicate testpath"README.md", :exist?

    assert_match version.to_s, shell_output("#{bin}pget --help", 1)
  end
end