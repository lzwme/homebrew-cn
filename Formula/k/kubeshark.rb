class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.90.tar.gz"
  sha256 "230d8331470bdfa82f4bc38107c92d35fdfc6baf57eb0bf46571c02a104c7bdb"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3f68a1b801ee5227454a09ff20e7a464a0bd76be82cebf7b69e756544cc2aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e023ebcca1af4c3ed25b6ac622e1747461e858c34132ad4137e38ccd4e2d2ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72d43f8e1d4ff795679db00fd61fcc86dca5ad82a795ad00f4b086e28d448987"
    sha256 cellar: :any_skip_relocation, sonoma:        "5adfafb08fbc4f88f565a2f760b7cf8b4f22f36fad91e034eb3ff03a72f63392"
    sha256 cellar: :any_skip_relocation, ventura:       "0a0b5bd9b2defda25afc8287d9a039838b14fcc244ad789b26f39d0aaa919b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14ee2d49c2ff0b9cf13aecd81466f809d04317c76a087e2be647ccd1db5c7a6"
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