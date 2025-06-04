class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.7.7.tar.gz"
  sha256 "fb5a674ab6aeab88a1240aa822d43303c7d5d24a680cbdf49d4123bb42ad5418"
  license "Apache-2.0"
  head "https:github.comkubesharkkubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c4636bcc950f34dbd284bee8fbab84089904c997789f10ef2a1c53cfbc31c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4edc31bcb4f35fa6ba6157dcb809f288034bfd031f89d55999afef3e1087b0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5987336952060db66c4f44c188f4ce7285794bb48a7dde9039f5d96f10da51ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d257ad6f05178016c238b905fc05754f05c0b7e04aff3c8002d94dcb8e78541"
    sha256 cellar: :any_skip_relocation, ventura:       "1fbe41422574a55986c4df0300d01c1e9dd150b7f28b5a498a4ae299ae3495e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a15b74330f5c92ac05799648732f2d92982997c250555b5bb2fb7b056897bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7010d1741c9dc71e8516b9642a233311c5b07a60455b2bcfdfe1669b42c602"
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

    generate_completions_from_executable(bin"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end