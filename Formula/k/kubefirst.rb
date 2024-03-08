class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.3.8.tar.gz"
  sha256 "480e302a56dc1128858a0816f1ea5976424574daf524bf967b9dd90e7ecc094a"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1036d7d140a837b331dd3a08deebfe9708fc2001577dca74c6efbcee1a01da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f4c2c4692e7f766c2621d31e94409779df072da1e18434a88aeee867451eb1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "319c039db791e289e26c5d60db39bbc658828856b412e121115ab37c044dbeb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c9b5a7ab27636d390196ff5d9f332c7a444d4fd3e8613ec64608eeb5161ddf2"
    sha256 cellar: :any_skip_relocation, ventura:        "c851b9d59bbe2fab7f57da51471d84089ce591fb3072b325e468e18edda0eaa9"
    sha256 cellar: :any_skip_relocation, monterey:       "68901cc4e353c2184330393812ee2d3431b3ff1f992d0a9a4688d2896f1b0b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c0e8e8ab8439d128e8f6df5e11a443526760067559b6b82b1f72f13ff83ce53"
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