class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.4.2.tar.gz"
  sha256 "cca57936bd79403f13f343c254267bc23bc3db56eb5e8ecc40b4963dcffe7412"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b03b9b77e08bd11b54045909bb37ba3b1505241fa14673faae0177195e019d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df44fdd7d3d92000ecdbc282d74e0a350b9ad19d1084bfab7265cbad22fae29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d9ba28a254e99c618df43c9b76f0589c0314821e3ca66ad24ea554ac8579efb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fd467a75deead7981f77f8790323c5e60c8c68366619776fb54662b2ad5563b"
    sha256 cellar: :any_skip_relocation, ventura:       "ee7c7decd4f8c5698a78f4ba6dd1321e42bf8ed2fedeb0788d15fea9bc43ab0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e394ae2609cc2b8dbc614e8e89f41f5199f21f6ad33298bb6d680d1c5782167f"
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