class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://ghfast.top/https://github.com/cilium/hubble/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "5c48a34a2e3ebd8b0b9e2c97991aea3765bc4c754a573ac5e77cf273c18d48a9"
  license "Apache-2.0"
  head "https://github.com/cilium/hubble.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3b501e65a0dc82794394121c9710279b14b8b637712c7cc9733de93a1c41e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "286d46cf7cafc6be534e0ab871469511ee925ecc159acdd0cbd437a22f4e9613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad58b341b833d45fd40a05f4d1e4b6b63c10f23354ac1c2e0228533ef09a2171"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86917ad5249cff540ce900bb127fb195289f30c0b06a57914967d5146ddd7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8a86fe61bdf7f058f6554796b2066b6af56ac4d8455f20d4090d7e2697a458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf8a337b9932dc7d26de629b2f7f73c2d68f7720414a656d8e19e076d5b21ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end