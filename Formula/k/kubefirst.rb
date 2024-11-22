class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.5.tar.gz"
  sha256 "10c3221644dd340c3edff97b9d57ff02285fc7764671dec944aa1e4b4e9ee83e"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17203f4aacfc0a0999faad40e096f5ed9829b60166101f7451e94a9ffa4e28de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe79efd58d01272836108fadc246cf7610d7a9afeeace008dda8a6d40bfb06f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc68256a4bbc9fe4cbcde64309f39193f67d9c1e7968034f987dcd33447c3287"
    sha256 cellar: :any_skip_relocation, sonoma:        "213b0a7d44e080b7f23f93973aaf579aeaf50dcccdac5dc786a493571ce8b92f"
    sha256 cellar: :any_skip_relocation, ventura:       "c351024ffec6eb250ce5d3ab3de6b2a75646335cb1d6d6c0b533bf81bd52388e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b650b094954e43881eeb1e28886d945cd2d36e9b2e5dfe68eeb60e8f6a4dc241"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkonstructiokubefirst-apiconfigs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin"kubefirst", "info"
    assert_match "k1-paths:", (testpath".kubefirst").read
    assert_predicate testpath".k1logs", :exist?

    output = shell_output("#{bin}kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end