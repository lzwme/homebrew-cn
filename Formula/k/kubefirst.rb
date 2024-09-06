class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.6.0.tar.gz"
  sha256 "a39ef43404e298f6d45f891b3a78d8813c5a515baf30e9c258b4b9c9c9b538d5"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcdc031abe5c051ef84867f19ba5aa93016d94e6c82f9164ba602efe33ed2480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82ee44f4a47ed6a781e293a8213c53bdd3a1a9752944e80368c2afd6edcd486d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad0e043672ff53c45cfd12fc4ffda3294ef628d6cdc814046e99698ed3b591e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e570d336aae4ff78c2b98fd426942fea5ff1411ef138fbec3f232b8f66698ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b9e975174c5ecf048e235792d332ead958e6146253f55bb044392516c9506ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "4763a541cce4de8232e9adecd89571953d3532c7acb523bf1a08a7d18c7219e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc86d3fc221aa0eb7c23c951f66870c23a9cc2665d7ce03e3ab2c97cd3497fe"
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