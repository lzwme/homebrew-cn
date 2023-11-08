class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "b6529903b8af149805dd5ec5c41310a103522d3a7398430f00746218c9a9603e"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d596b7fc05dff0cd159b7d6a0f00b87230b1a0286de3e4b48ddad19913b28009"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d9e300543495d497831230bf3227f1de7b185948d1263e7f96bc6d9a512d45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8906967de3a5675498446a09871777c208a24b4ecd86557de8443484cf12c61e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d418a7ed1a9f421531df5d60af7bb1dbceaf5aca16d71f658dfba4371f1774d"
    sha256 cellar: :any_skip_relocation, ventura:        "1f37ccfa16d039cd17335b12e88653adc16670e1572e1379d9400535005e3330"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf4336901b2dc03e66f2161558b81112d5c35ba8f955231e1a693a565e1cecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77a3c5a09438177c95d37d656c30b9a5b03e3cba772785a3928d93df1a3b18b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end