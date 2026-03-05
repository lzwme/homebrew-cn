class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.17.0.tar.gz"
  sha256 "cb0f4e123e9c058359fbebb07ebd7b936c130dab8d8e7d5c6e626c442d89bc54"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01fb5664b584edb406012f272c2e7f4babf541786e35d14ae6565f3019806c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3bf0b1c2203e748a518eae4bd24c0dc67b969705916b66faf5ebdfe596e1852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d47213d9972435d3fa6040a6313a78034eb8e4c76173c28f130daf826825b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8fe200727d4d76d07e6b3544c6e81a3d0ecae6834fa8ec48796a57b5f770e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ed7915b98b7f54e3715f277399316030442dc947c28f13ef702d993b802f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad29e6c85e524e23c5509a6038a0b86681b90fd8a41a23fd6c238fbe6f7f6756"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end