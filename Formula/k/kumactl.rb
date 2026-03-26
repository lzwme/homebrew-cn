class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "161896c45adfd71a6acfa18d8643a276313bae036e771925358e3dc7d9239108"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c21404783c1fb19a886a5f2a884da7338c1d38a68d0428d2dbd5a3167f8f450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68aece0a2faac6157e3c41a2b1987c7640109b8f5a317d755ba6eca671dfdc33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c9c1af58aa08ba0adeeac2f2efb4abca2ab89c10a3091449f3e3ece2370f00"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c90a5cfe26f3990d7e8607a377af449db8d466f50380588e7585a53f9259b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5baf4a8ab58f215c6f3739689bd5af5cbc6eed5646943af77cb6d0bee05b4d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d631715d5e248450eee4b188f83c5dda60fc22d138b96a9aba284b770cdf7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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