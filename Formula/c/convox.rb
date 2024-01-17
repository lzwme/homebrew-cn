class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.15.0.tar.gz"
  sha256 "1b5a877c62c770d394afe88cf1457cae021c6e690111bb817f852c697e7fd970"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4894ec0b9877e72a7b261e6454063c6ee376ff7582f9b62765efcbcb48e45691"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da6f3b9686c84f98f0b0de6a79fc513145eb3e526387f474d949557091d52015"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a19fd11ea63ce8482c2c709f8b82186b193b229657d2c8365cecee82f62afff"
    sha256 cellar: :any_skip_relocation, sonoma:         "432d904cff10b0711d9bfadb41963d619ac4f23f4bbab246ac4bf5b6c17daf68"
    sha256 cellar: :any_skip_relocation, ventura:        "95bf86249626f729ed4a16d46ad3054644d8544309a79bfbf1f5b098e44e4426"
    sha256 cellar: :any_skip_relocation, monterey:       "9228c72b15f0f8f9b7d3d2b4ba3ef1bff713b6edbf2f20d34e02795e3888f421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b770241f4a6c87b7133e2a02a2446dabdcdf4f3f875d8390cfcd822a736d58"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end