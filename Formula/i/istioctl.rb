class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghproxy.com/https://github.com/istio/istio/archive/refs/tags/1.19.4.tar.gz"
  sha256 "5a3a1b8c5d0092a00d1b19247cbd066307ddff1bc8f8c2551a97cc8e36035a79"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "757f7078089979c2f5095178c93d0bb5edd2ea66280c979aa5781b5228430c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1365856094af73d3d7ec001fbdfc54684fb3ddcf887da74adc8a3a164520cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0e94eb68229f941831c89bcfc5e364ff4f54976f2300b5c9a57699af5aa66a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5d9e7d11646e37c31e8ad0a2132fa170e60d989b06adffedcca66e7fb25482a"
    sha256 cellar: :any_skip_relocation, ventura:        "a5560db1a1f302f9917ecf37c47d550051ee5c734dd0a0ed15629e0ea63584c5"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d19a1ed3e00d299c3f4e9016401ee6fadc29170913a4b1fd87dd76ec43688f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63816f41a94c8ba7a64e69205022e6a82936104ddd969516796a72ff5a4ef82"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end