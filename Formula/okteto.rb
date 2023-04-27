class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.15.1.tar.gz"
  sha256 "efb4172ba714a65a18b8a07c8a2c89036ee770947edf1886af777a18364f59a6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71749470b86aac222604d510087284049e6116a3dcc2f2e1be30acf3798015a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c71666243c3ffd1ed2cc572e960e229269c4cfacd39cfe55fa1df780ef2f2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb819ff447deade807e281c1c0b775da4a1d75178fc3eeff94aaaa3fd98c3d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "a73fe5855188c74603b97b59e9355375bccc2fcc13bf36e1a19e01b9d668735d"
    sha256 cellar: :any_skip_relocation, monterey:       "0da1cbf5d08b9c877bcac1c1807de81dd1b38a5436c2cdeccb599ec330838000"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e13ade30c51970941868d228a99ced626e162cc531a5ce4c652ed32ac1355ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e494370f391e6a643c58c95f33dadc435e7a881f03dc8d67638b1798e5ab10"
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