class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.23.0.tar.gz"
  sha256 "a5654c816abb41a3ed8fedf930e6ccbfc35109d34423c904a75f8b81556632b8"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c098e287db4344916c6c740898bc182c495a6d57dad48db635850719602f8c99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8dfd5009f23615b127c8d59cf1cd2a7553931e94ab6682c6aaf11d0170041e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cbad19627c5df18eabcdc7f3fd0cf3a6b9b3567c29e8040d347b2611b1e779c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3307fb5d8a4134557fee831acdbac746b3bc07954f18ee1f8c56851571ee2ddf"
    sha256 cellar: :any,                 x86_64_linux:  "7a970cef39409d8a4966beebb035fbbd8aef10cf1d4626ad564f7b2b6be03032"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end