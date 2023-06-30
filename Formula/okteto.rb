class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.16.5.tar.gz"
  sha256 "f049aed88c40f02ff49274857660bc0bac1f8d5a4fa19d6abcd081aedf8b1036"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e47429250867964ac4ec88528b549854933ba347bf790802b46476149f22c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "785e704936d19f25251387f0f1591bf3107d85536fbfae71ffea08d544506c00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e81f3b74b75584ed65859a1eb46c41412f45cf1f7037068b0f936bf9d6d7ed4"
    sha256 cellar: :any_skip_relocation, ventura:        "b443e85d55496023aa654261286b3d686977821d733271b4dbc2ca98d03b6e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c9c7679119fd99088e9f624d55ddfbbdf596e27af096f5af040c74fe68d8bb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0c40fef76377862a9410f793e1a49db138d085e247b0aed0ee48d927abef01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc5f36e7dc819c2bb20c1e427d56bd66339a8ed8e823467f0f7472fd44f0a53"
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