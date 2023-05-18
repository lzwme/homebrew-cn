class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.5.0",
    revision: "38a122182665a4fe47d54ce99ad5a3f290080742"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d80a74f9773f763b9ee67b8d807bd72360db731ba5d9eb702a0972c9eac2cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2d80a74f9773f763b9ee67b8d807bd72360db731ba5d9eb702a0972c9eac2cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d80a74f9773f763b9ee67b8d807bd72360db731ba5d9eb702a0972c9eac2cf"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb73a6d79c3125ab3f9b56d4ff8228409ebc3f0276331723398fb0b50717d82"
    sha256 cellar: :any_skip_relocation, monterey:       "5cb73a6d79c3125ab3f9b56d4ff8228409ebc3f0276331723398fb0b50717d82"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cb73a6d79c3125ab3f9b56d4ff8228409ebc3f0276331723398fb0b50717d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831f3b76fb0c0f42e0c3ff61fc087858e0d2b60a80d870b9df7a4ebc70ea19dc"
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