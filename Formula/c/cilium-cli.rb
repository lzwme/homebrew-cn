class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.8.tar.gz"
  sha256 "f09c45fd363b880c10435525a340d0a04505c1fd3e5903bdf49da13cd7330415"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f07e240cd70246e97bfc92be82c0965a4bfae5cd1ed848927d7018a584c6e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8d6879727a6ed5e6cbd75874bd8657c13d1c3d8176b39d9e9b912498fc41ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa51590f090bd14b144c356d802732c530e54d391d676913c138c59f2e463b61"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4f6a820bd828d2a1de48c19b12948822d8ec5c7a018f878724f7fcee79bd0f9"
    sha256 cellar: :any_skip_relocation, ventura:        "04b8ee13b38df31ae4c6965aed16ae6dd253db3da85a9f7c3b41756184001462"
    sha256 cellar: :any_skip_relocation, monterey:       "89d71a4064049352090e5e12014b04889a8830394a464399cb5552783d40f03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6863d1e7c648b13294c64b83584eeaf88d8e6efb7ee8ecdf52eb664f3bad61b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clidefaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"cilium"), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end