class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.24.tar.gz"
  sha256 "9cf4dfeb150912dc4d5b1466185d7a5dc3239e4e93164486f2f530bb3a37d1fd"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "619b30b3e220aa90e0f0302c374115e5a6df569559acd8491a6691ecb01268f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cad118e8e0d8861869b99bf5a4087602d3d49f1b7cfd86c2fa8d35c0c34c06f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc338afbfbaefba760fbd94f4ccdac42894be04f707961fee4103d732332febd"
    sha256 cellar: :any_skip_relocation, sonoma:         "03a3fc481e0dc2ec49c7f495aeea4714c524cfebaba6e58b1bf9b72e32de5852"
    sha256 cellar: :any_skip_relocation, ventura:        "51adc9b166b991099a3ed2c9bc40c25eee748053b59b1a458ca5d90dd52868cc"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e1ffe8f0002ce3637eed077123d4593876745ba496bf60188c766157de68b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f4773fdda9f028aa216f2a9ba516fc11a8389c9fa2f5d0cb3987302fe75101"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end