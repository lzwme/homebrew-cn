class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.11.tar.gz"
  sha256 "d144345b19af1451a0f8576f75106c117e462083653db56c9f1f53bbcd08380b"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbb97688376902560d559e0c2c1043e9366b5d52e8dba265b5bf49f73c349512"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46709bbf136f822d803e7922ae75c7b08aaab751ec63aba26a8e0dc2b4fc8a92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "232713d72f829ca45eddb0ca5bfd939d01c21adfd59dc520520a05f1733cbb13"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a720c45c91ee80a881032aca2bab6a78081f980a3ea9a762baf7a4315ed57a0"
    sha256 cellar: :any_skip_relocation, ventura:        "12c8b1468b441149b89af6371d3d6f833cc203e6417ff13683babd5c2abeb866"
    sha256 cellar: :any_skip_relocation, monterey:       "2f91d6e0b131a3b2bd68b500562a68390f9451a040e0a516d562ed1077bc6b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e9ed348fcc60d79c0f930b618689a50408411bf27eb8582b907dc29fb42ca5"
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