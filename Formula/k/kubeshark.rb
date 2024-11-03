class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.88.tar.gz"
  sha256 "b3d1d7ba4767c993351b7b64e782adc065ecee38be8fed761e9375163eb7a270"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca80d59146797c0edb7eaa1c0aa5c8ec98abf0c6523388f06ccdddeba253bbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d2ed39fc4fe476f4ecdfbc20bc96625c7dce343b59a779f83ce4bef29b0ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6534384996556d53c3bb8a5f0e36ddb6693e977f47640ed40e9f4e32f86a2438"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8348a3557191a497d0b80ea3fd08c1e72ace133601cfb2e1d0c06a09df7228c"
    sha256 cellar: :any_skip_relocation, ventura:       "2411a7842b38c313023e43d0dc18525b95c6b6d02778a9a6bc295a0e6c708536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3106a39d21aebb9afe5fc42c6dfc4f07f51dbb307b8eab334f370980eb5986b"
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