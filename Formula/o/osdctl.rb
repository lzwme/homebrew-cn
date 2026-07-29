class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://ghfast.top/https://github.com/openshift/osdctl/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "0e0543ef9760f827dedc91605c64e484c68e387a86e89cb579ebfa263d687ea2"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5bc5c305f41f643f4dcc3a62b06ccab6bf0c735b860a54d3e11d5eac3b5d0e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5bc5c305f41f643f4dcc3a62b06ccab6bf0c735b860a54d3e11d5eac3b5d0e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5bc5c305f41f643f4dcc3a62b06ccab6bf0c735b860a54d3e11d5eac3b5d0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f2a32f16a0d55a3445e05abe628146188d1e92efe885f807b4280e29df1ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f26a5647d11271f8b374d7bcca9c134e26af9496057dc15aa0ce6522ab580e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8bf7ba6d6fba69c4fdc92c4e3dd94c618c2b0ff23c4dc92c16fc1865a47b16"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end