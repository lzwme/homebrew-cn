class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.5.10.tar.gz"
  sha256 "18d22e6c455a0d8b2f7113f1514daad4fb03baa2dca452b2149e6514c010ad3c"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee6d65c93b0b500367bb9386afa2b6e5da7459eb36c4d45eb2ba8c38bc9a7ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a081ace06361cd7ec15caf7e0ef70b8b6a1ead35eb8534d3d962faa4d234dd5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9262c612bd091647f1565c2947ba54e08552411679345178c70214677f535508"
    sha256 cellar: :any_skip_relocation, sonoma:         "da22ea8cfc835937c49499699caf5d9378e7ff2397ad1d8749a5c0b5c103680b"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4aa43e94badfc9d2fcbc35741c96dd26a80ebba0c2e9819ea3bb403edad990"
    sha256 cellar: :any_skip_relocation, monterey:       "2d08fae4e224e65de76436ec83133563e9d8f36a0fa6f52ef88ef32536b1c01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e783d09b26c975e2e2a40a733fa7a29a1e609a52df2b1a65514561c46217c9"
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