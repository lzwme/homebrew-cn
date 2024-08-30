class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.5.3.tar.gz"
  sha256 "dfb956f5516bc7d08d26eef4e7e5a3a4052bb317671c21195467441147ae70fb"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "756fa121d344cd74a29826544d530c22670b4319236ce0812abb03c8b1d36f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0201d86ec6e8694ffd07527d0d943f92fa565382a27c164a4031bb20935f4013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5423c6df0cd6011d0341ab03588fd5640493c1de21b2cd80ba9c5f852c8f786"
    sha256 cellar: :any_skip_relocation, sonoma:         "11f649e5bf953b90a2e82a8566404d76650c5c172ff07dc305d4c4e34dbb005f"
    sha256 cellar: :any_skip_relocation, ventura:        "ef36ea52148399f63402ddc5cf4f7bf778720f8202ce91123c8d44f1ee49e19e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3982b4a2db9b12ab2d430955f76beabe609b3dd8859b9b98320cbd57eb41265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5de516c879db9d8987005566ca0553ea8916a7ac9417a5fec5bb104096e896b"
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