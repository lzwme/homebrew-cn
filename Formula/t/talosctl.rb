class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "1b5684747e2832c154df6c0b67a310cb816feda06d644a8c68d2ac770d6179e1"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f6a832460bf63c16dc1ff4ca0ade8f2c93605463594e4d96e2d74f9e1cb1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2666951eb52b00fc42233265666e171187ac587bd0ab2fa7134ed41fb3ca22ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62c9c8b0a1ecef340b9644b5d4981315e63d3cb2199fd66ebd6577cbfe7c21f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc2bbeb7277f20ddf13cea1a98831b4d2f212da09c8821ea54f47d1bcd469f55"
    sha256 cellar: :any_skip_relocation, ventura:       "cb5955b06c63919a137cf4fb270f0bb5df24f0780699758e0bf29c320186fe3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3090a03fde0222376969f2d07d8cda7e37de2cca7a83e45f2596645aaad887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2a9c4a1013d88fa712424efa94e1be974dd510bf8ff4285e0822345fb91412"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end