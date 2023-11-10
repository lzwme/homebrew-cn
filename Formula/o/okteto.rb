class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/refs/tags/2.22.2.tar.gz"
  sha256 "7cda3b550336b2cf5c4885bc222911aa01037c05f37464890c392c85ec908043"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7effedf63c386f577fc09dc34d791267fcf9e01605f2c717bb8bf796d8c573cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2450ce8b150e8354433cf465b22184cf50a69c0b37de8901bb0a6122490ba366"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac40c6e6fe3b1f39f529f87cc57b730b83c3c29e67b18ffd47e88dd47af70a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eedd2406438addd80df8756495b54473fa86a3b8aa762a969fafaf235c8f679"
    sha256 cellar: :any_skip_relocation, ventura:        "084051c407e1c4ed8f9495b3a2e2be660db8d872a7659822b0f12053fce6c72f"
    sha256 cellar: :any_skip_relocation, monterey:       "b9380daea305616fdce89e5e797c1e522feb496f2696879b9d6cdd4a93213ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591b8b3fda54586dc7bb49c03acc64d3d7072c4ac79472b0c99d665341a65a48"
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