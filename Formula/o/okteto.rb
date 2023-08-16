class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.18.3.tar.gz"
  sha256 "d66f6bc23f4495316b7459c1384cfe4f165fa6763cdc2d9da08d5e54d9d58e91"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7574a62fc2ff72a97d5fd94bddecea309a339fb756e3a30543ebf8a1b452bfc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7d7472b7566838d81dbaea73ee83f3ecaef4ace52eee933c20eb88bb80d2a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "095715aa7e3e283e9b77ca90d3eb242ff25474519e3dcaee24ef5254f38b67bc"
    sha256 cellar: :any_skip_relocation, ventura:        "b23557edd11077c01df68bbebecb9273537439ea430632ade0418deca1a0c618"
    sha256 cellar: :any_skip_relocation, monterey:       "e3e6627fae8d63edf1a5d3d45090cd84fe4796b61d5aa2bc427e24a4bc77f529"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d57220755f3a11f510a20a9ab0881d357de8707a9a48bcd3e5f525984a8a911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ffea650e2a70de409b6d40207de6a870351909422360244263c6adf696cb04f"
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