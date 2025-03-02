class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.5.0.tar.gz"
  sha256 "45b241971ce874e7120f31c280f20619b5f7224f00b742994bb47b2999cdd1c3"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4983297136a1358d0af26d81bb29d0e4096f9895f5c66fba51c11b86d1ec4471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56943fc031dfa9f38af7a0cbcd617ea8442e4dfc94957a780c0fb95d450988b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65b5e9eb7ed531961d135b9e93f4bced5d16f21e85d840ee1daf93a03daab0d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e222978864f6d3aaabc53757f8e8b9256baeb532b7db47db8d05f64041cac6"
    sha256 cellar: :any_skip_relocation, ventura:       "57ece40f73fb636d2f19a1729682bdfd6b85ff05222a5f6ba25332f6add454b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a3393c35f80d2c5650553723de70544cb3fd8b348404ca34c755ab70da448af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.comkubesharkkubesharkmisc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.comkubesharkkubesharkmisc.BuildTimestamp=#{time}"
      -X "github.comkubesharkkubesharkmisc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end