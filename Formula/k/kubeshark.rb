class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.92.tar.gz"
  sha256 "191aedeb123dcdfcc5ac4618829928ae629173fedcd4a442f825bb6cb61a0c97"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c8eca89a192349ca5a0bedc1b7e272fb37cbe60faa2169aec20414f236fcbfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6add4fbd8705a2454dec45aa82ff9bcc42eb8c67c99a3aa336e4d8dc68b92437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f59014ddab0a3774b401effa785684de5b73780e6a6a993337718a7c4d15622f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d867f9ffbf3e09f53dd1532da607f5194a230103c99dea9eae490f7144fec064"
    sha256 cellar: :any_skip_relocation, ventura:       "aceffdf910e8d79877bad779794a9b5b85ef640df960e70a729e5a5156b9f9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dded6550213d2f0c60e1f25d0e58562954fdfe207e8eae7e3017b5660e08ad0f"
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