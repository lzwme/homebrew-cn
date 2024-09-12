class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.79.tar.gz"
  sha256 "682f3c8622c9a75905de1528f49d96a77294bfe5dc697314b0b0f3a6e34fb78b"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07420ff894da3ccb259f73e69bb1e54906c957d97cc7c6d17cb8e0cfa4a81045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d1620697f94fed6dac81414d084417f93d21fa7108f69abd8210ea302e5d9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a85c1ae4eb49f23b0efc2bf50e77c50237c1b611a38bfffe5d0071711600083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15a2b6eca3ff04320fc2648d4c9214f796f3fc453b823672e09600b02626067"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3d27d18e3403a8b4f96bb10f28db1cd48dbb639395186656e537d0e32c3ccc0"
    sha256 cellar: :any_skip_relocation, ventura:        "2310f5ec8a2db48d2f887512ed7988216a71344a0039f165d487e5ba584d5433"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7e3d17bae9a2ef13e136823db03842c7265971d5af6b335af794dd5feb1548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0160355aec1102fac6a1949164b963fcd431dd5bacce883c03a4fc77eebb0b"
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
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end