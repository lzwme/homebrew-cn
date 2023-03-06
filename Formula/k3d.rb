class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.8",
    revision: "5e5f56f7ec8f9be76bf301809f361ce6672d589d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95e4b3e4d4538f1383804a14195c3a7d3fdbd1a52b34675d01e04c1e3371960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e95e4b3e4d4538f1383804a14195c3a7d3fdbd1a52b34675d01e04c1e3371960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e95e4b3e4d4538f1383804a14195c3a7d3fdbd1a52b34675d01e04c1e3371960"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6fb66c7c943e125a6570c6ae3547edd9304acb7f6b2bc74f0d381fdf3e2d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "fb6fb66c7c943e125a6570c6ae3547edd9304acb7f6b2bc74f0d381fdf3e2d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb6fb66c7c943e125a6570c6ae3547edd9304acb7f6b2bc74f0d381fdf3e2d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326b06b516deed6aba37bf717f0686ca6d6aeb93f368062b4b498d2e89855c0f"
  end

  depends_on "go" => :build

  def install
    require "net/http"
    uri = URI("https://update.k3s.io/v1-release/channels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")

    ldflags = %W[
      -s -w
      -X github.com/k3d-io/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/k3d-io/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3d", "completion")
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end