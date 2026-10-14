class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.14.6.tar.gz"
  sha256 "7bfacaf7831033702ad7537bc3dbbd5b1d2c63b258158b2f3f36efb5dd19a776"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86bb1096532344f0adc65a0f55afab22d726b67921eda55dca4316dd1dce70a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "380966a50daa0b37e32e563260f81792b6500957dd1abee9a18b8ca98094865b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d081fb7372c36554f27b5a57f2b95307640b052f4555d06baf6134035345da33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8aa306d1e0aba0b25f26359f8a17ca70ae95477cc436d91312b2a1938c9c4ec1"
    sha256 cellar: :any,                 x86_64_linux:      "4be70d966f5fb8c84395029b005b08d33c51d49fe3df0f7152d9dafe6bf184b0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end