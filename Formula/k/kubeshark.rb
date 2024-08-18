class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.76.tar.gz"
  sha256 "c7d5a929c8c19c0f327049713e4f31ce194bd54745ecde45b586c0f2bcd0b116"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c169de838c63021729dfd1e68588bed2c6cb401813b8e9d49577c1ff7682127a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1ee7fba6dd5d3714303eea233b1ba85d522d8b17ba46252f07f05f9b2a5b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b513a1d3bfd6796c6995bcceab62a514d491fdfe8880e0b8778a1e8e7d3d334"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b875bedff1cca53c9b8e26798af2bf2fce08dc2d6e98c04a9fe89efa2f355c0"
    sha256 cellar: :any_skip_relocation, ventura:        "030310a95cd3a47728c8fee47cfed20262c900224ecfe2d3270c238095acf04f"
    sha256 cellar: :any_skip_relocation, monterey:       "59148b4a22f6dae7d993377e9d0e6d31684904767f84de7021a2a1f949d1c925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14113fc3c29b4b6f3372ebba7ef1f7b6d4071edcbd33270e48f372b0e3e80d7f"
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