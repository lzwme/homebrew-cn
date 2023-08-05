class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.18.1.tar.gz"
  sha256 "52a08490eef97b029e164a5141616361e76eb241fcb28fdb344911c678a7ef0f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f5b804aa6a61205f5bcd99b0ec61b854b6df20275008ac035d7ffd74e63469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3467bdb4024fbbdd69b26b00fb7b217a3ec3b67b88bd82477fdce72dd570f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7418fb9efbabe29b498db4f4acfc39e80957266abf2f222bffb75235cedcd395"
    sha256 cellar: :any_skip_relocation, ventura:        "7280fc0ae32a4b21e11e0a8d722cb09eead663210461045afa784e159454c253"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d40a682472a1f0c915e2e1db44bd0c407614c8f43d4a8c78fd87248bf09e3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "162781035df8483fbca3b4119a04ba7986766a72a8dd7574b68c95cf00af2328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b88608dc240f384569669b4192c8df5c0a163a0df492892a31e4c1b1d27b0e1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end