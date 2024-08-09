class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.73.tar.gz"
  sha256 "f1a4bdeb651f41bddf72fea6ad82e45ea46139bc00b4fb16266bdd50a0e78dcb"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4267a86f707d9715185ceea4edb981108799f0819c9b826bcf5e7a4df2eb8d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1842aa08ff19a657fb9723beb31982c060840b18f5d4bc88ae0cb2a2ce5074b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83ad3f3a1164439faf3b453234269bc12d7e0e16acf20f46ebc4e83679ed457"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a9938ba5d984fdf638fad1f68117186bc30d18391f008b719d7467977e4a295"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1b01f0bfc7391209157227c79c124e7828fccdcdc3097e46fe4e6f2010af97"
    sha256 cellar: :any_skip_relocation, monterey:       "3419143ba3b8c2524a3e9feb24ca882e1127a7147d22d96be82d53f36b84f020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d9cb055f488e1c8fb5a25c71ba8c91e625b8194c3a8305ee2761578a8fe88e"
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