class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.10.3.tar.gz"
  sha256 "f9865dc7aacaed3a6bcbbe881c791a1dcb2e68ba37a5918000caf8574933acfc"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098f252786e3f89eecdf614651726b7af08259ab61b9c3b128737e0b7629ea2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4750b580e45398cf5777aaa4d236ce719e81a969f5118bbf1cf611c9bf829275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebcc3c5f92ccbe102dc3b03e8e7a3b0c622b2cd8907b808a7facee0d7138cc5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dad043a8cbc0c37877978407c3781cfafb1e1ebeae814a6bb8671176274c714f"
    sha256 cellar: :any_skip_relocation, ventura:        "741d0f343ead964103fa431680bf56334da75b2727d47e985850fd2695204b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "abbe94865a7d1a777a0ab975986df64643bdef60c40a36b9ddf132468f2f73a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70928e87501a4ba0b7fc68d84cb6dc821a215d41393a9c0b4933936ac2635289"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkarmada-iokarmadapkgversion.gitVersion=#{version}
      -X github.comkarmada-iokarmadapkgversion.gitCommit=
      -X github.comkarmada-iokarmadapkgversion.gitTreeState=clean
      -X github.comkarmada-iokarmadapkgversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkarmadactl"

    generate_completions_from_executable(bin"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}karmadactl version")
  end
end