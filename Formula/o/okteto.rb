class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.24.0.tar.gz"
  sha256 "91825784f0e873416fbac86f1a1051667a0a39580060629370e8d8ea56551f27"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc26570616e0002f509c8e22d2ddd47eb23a56e50859a6bc2f815bbf9242cb34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ace6991c80b6647836623f6076be87a6c2fec05a87507733fc069f92f2f6e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bf699bec02c788828d77513a1b44b1a81fd2c2d8824dfd74debdb9040865e4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea2969f8318439473a0d12c7ee031fa898f6bebbd8ea5db3c15e1806db9c249c"
    sha256 cellar: :any_skip_relocation, ventura:        "db4d94b50cca5aed455a8a9bc52703b1cd20446e635339fdd194182d592deb12"
    sha256 cellar: :any_skip_relocation, monterey:       "e263a1bfc1cc068670a9e262c47f1630963dea5adab996b232fc4acdab3a29ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c975d6ae43fb78317a061fd90b4fed4cead907d33777bccfdfbe52c0640ea1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end