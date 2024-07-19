class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.13.tar.gz"
  sha256 "ef873999070e3f615686a45054622e78ff3998aae8de8066c7e8f2b88efe5154"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd98141831a752bb50d014a5f00edd860f28833a0492afe957e360aaf88f905e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9642e6d0e2aad3107e899a72018728376ffa06126438a0d9e9c52c0105d9b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f8a543ee5969c6b105645d718512af1f3abfd8d2fb2acfab86203ef15c5a25"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1d1eb5623b9d0deccaee579462501a455b1633c7252b4aa12189f4cbc812ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "7382eb8e53ef1af16fe040664a963f1b183f0103f0a2eaf914a5159be5043fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "2e34dbc5306e32fa2dff35f0770be1b39be2b6b5f1f87fc8a37717db5696399f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9ce03b6792724607e38552164f1ddab369e9b40f480163ca5d26f40e0c2a64"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstkubefirst-apiconfigs.K1Version=v#{version}"
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