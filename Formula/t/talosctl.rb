class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "00e51df1940b836fdbc148d8c263823669e20aa5f6424b3be15127c6cc89acc9"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a20d4daa8d9b9bb48ef7b95e2ae0d74a09b844f82f072156271243d855941b6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7e45e46cfa47e4e079a919466eb259fa81d46fdd3faebfd4112427bd24e43e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af01b6b7464d581bcb5d3b12b749f389420e75cd6a38efba15c50294e21cca96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c6c1f53fefd05e9b14cc9b69c1e667852de463ff6dae6e3b18b606706c91eec"
    sha256 cellar: :any,                 x86_64_linux:      "f294d847e70f4550ee77c4a635cc1474ea9a71f4db0c168c56d74b9287114fc7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    assert_match "failed to determine endpoints", output
  end
end