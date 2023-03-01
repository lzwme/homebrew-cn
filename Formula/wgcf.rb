class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://ghproxy.com/https://github.com/ViRb3/wgcf/archive/v2.2.15.tar.gz"
  sha256 "b12971018c40d0a04492a9da9e9fea393394291044045e0117ec292364de1b57"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a427a9556174eb77f404b02b335614b01433a261a5ba0dccc2db05789beade1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6a7f6b4e419a4d40eb206e4e315e453419dd1a30a8e9c14559317a6153c26a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "138f63fd7b77d2d544da1994b121254656a5575473eab98d58f51886195cc69f"
    sha256 cellar: :any_skip_relocation, ventura:        "259a17979ea66edcde33804c225c7395d785e4a6537e6c84f21013b138102257"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc1d0b6cdf73841f546cc6aca5e293ad9513388cbcd271876fd6c38276c585f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1596717bc3872063cc4a72a0eb8688e77f73d21e113bfc741004466735313f52"
    sha256 cellar: :any_skip_relocation, catalina:       "b59e53c9b0ea5261159b57c0b4378b9dfb5dbb2302b3b394cad893fcf08746af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cd6e8e0bb51b09d1c9fd9fa3adbb497938af3759dbf53fbd00b00e4a38279c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end