class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.11.4.tar.gz"
  sha256 "f55589adcac7e08d6d3a38b08ceb83eb73ee7042297f915e4bf1d5e28c23b4b2"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32d46642001bdcd3cfe2bfb8e58fc63ac55075704059b53a61bf105bb25e1e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f7efe37910db20e86cf40198a2f5c959795d8074140b3ff51bd032bb7054a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0315d83990bf8c2a634bd7f86be080515533f3478bd331759ba38e74be313cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "13320d21aff884c64e70937604eae91c79a08115b2569ee8208144ecc4b01c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "99e97d26c8d765df8edf0eae773b072916a1cc42c0ef3f299f6aa9eac8dd3f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2adb3bf50ec44852f9c07f0d9d758ff5e444b2f3ca3b0211d5e519d886e5f0e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end