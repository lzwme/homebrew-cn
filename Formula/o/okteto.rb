class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.14.0.tar.gz"
  sha256 "ac052a6538a5a4475159db3dcf613a9af5de2cb04673ab79c346a70bc02e9ce2"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d90151af09048f1cb3fbb1d2ba202a5d7ebde0dc5a3c1ecf189fc025bb7405b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e509975ba80833a6aed82c115fac2be13625b86c800d779d019f4899e90551d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c62689f41d013f8c6c2710bf9e9c3946c35283f39755679b74cf5aa20acd08"
    sha256 cellar: :any_skip_relocation, sonoma:        "02aae418cf2a518b4a1b425ff1849342f5e95fef8c4b892d63ea80305d330bab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2bbab309828b993b647c5ee799c97a0353735b607303767a755a76a5623199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac346b1ea7187e0a90c1bed13c46c34231992bbeb8412e89c4f33e3439440f6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end