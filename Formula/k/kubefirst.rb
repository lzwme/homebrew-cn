class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.5.tar.gz"
  sha256 "9705cc5c90db51cc73a925ee601c09d6def8b559060436f00c2a9fcf6194825f"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f399f061fda868e986ac7f637a5f229106c77c36e80590ea33e84e02e703e680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a61f6c32d36d1ff1a9aa875d415b4858bb6f27e0b83f5070d186f27f832ce729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "596fedc82e125df56e304348d060ac4452c908ef4285736600f5da897d359b5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "336060f06ccc2884c408a2dcde5524989650725ad265b1a398821fcf8b21c7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a150a92fa553ba88245ed93788fa34d905875d14263b0905de80d6bfdf77fc96"
    sha256 cellar: :any_skip_relocation, monterey:       "5544a71a77831696d5cb6c15c6b5527e0db6590fb0fa1b5337d3d5c475f59eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1de797a9eb1680b32bf2dd26144e167b8543f760c990ece64d8bf7df1e1bba3c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstruntimeconfigs.K1Version=v#{version}"
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