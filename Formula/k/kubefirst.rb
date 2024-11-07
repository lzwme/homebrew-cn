class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.4.tar.gz"
  sha256 "54ed3e0590454ba0f1525c3ca490df5efabd6f8a881363843578e1aa70a919f0"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfa6d66f4956a1f0ed41a77705c9d5e5421cd765270e46ba96530c3ab1fff24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba68d43f75cc6837e47d8838d11074ce7f6f2084b14d46187e22c48c3d8ce518"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fba8db8232a7f151bb6815872eda95fe4fc42c466a5e9c67820884f1a6f39b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a8cd593f5c233003c12776d69b7ba9e37be0afc8e725db41fda5bec65ca515"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c6e1f9f13f8d0044c7c439a5224ceca433e7083442224a4ce30781cfee687c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2286c47f7dcaf34408448667908dd3fe6106a8bf01f1100f07cc3aa5257917"
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