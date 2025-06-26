class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.11.1.tar.gz"
  sha256 "0a18d919efdbaae3ca725aa9c33fe7441e99d7ba230b84145f90018f1c00b267"
  license "Apache-2.0"
  head "https:github.comkumahqkuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ff3e10dfa59342a442b1715a109ef50eddcb7b5cade3076070e64227d90841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4f1bfb0df2d031e9654f993768f7c9fb31ed2a5229a8d40e5836a3c84c775c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58087a53877d636c419376fdc64255b452656ea0686c2fbef1c10a505f1eac4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "af2e194eeb1599bc7399fe82089306aedfd026d8b4df9cb59b53d70655a7beb1"
    sha256 cellar: :any_skip_relocation, ventura:       "6b185e4e7fc82c73915f142af2d88ecd5798a759b86ae6bdfe3b331319a13019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b55821da8620dfce86232ea8ba12674a76050ea52090239d3b9eb224686755"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end