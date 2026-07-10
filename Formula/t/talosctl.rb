class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "8e08a279ef826c50e98ce8953dcc140d66f40c59922ab794d67b3e39f938f1f7"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dc6a38e38192761096e2fda9341815c7bcd53b0e2a104a186a1ff9c8efc5980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97be66bc3f8f7e312fb65d69341ac896a00747e31de25f9e1a19d80ec0ed4c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af059252d581b9e88cd7f2e575c6cd1dbefd824fbe77f4a1b78480770809cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef8f96a9a29e109946680cebb2846d39c574ca35f2e0c364fdfeac29d975511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b33d2bd6894f60b068c89e43f8c69dfdb81f42b35145ca1324f31eb397c300ef"
    sha256 cellar: :any,                 x86_64_linux:  "bdadaae0ffb9df6bd26a8ad112f16f3cf41ad06f1b70339e24b258e3b2450a9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", shell_parameter_format: :cobra)
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end