class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "e95fb856af66ddec36368fcb30980b75efe808c7e48db71a55716fe811edbbfa"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fb1840d6dfe0cea843da83a75767c8fc8ab6df3dd02b3ddc925b82b4a3267e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e5c56d422f372f97b824b5b3b93672dbd481247c6f8b13189184f1491b0377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c80f0bc9d032436872fae2ee9944f96a7f0facb18feda6a716b464219036dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd8a6cdeab5e824fefcec607da4a10acd3af44caf690f04b5e6ec59b5a8da58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1594a2a85054e7f31e70933a62cf2a331a7f94b63d8950271ef77b2f980613f0"
    sha256 cellar: :any,                 x86_64_linux:  "93b6f8e3aa0124f745b18367e96814b2ae5fdaab4b502cc57cbe988bcd31d70f"
  end

  depends_on "go" => :build

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
    assert_match "error constructing client: failed to determine endpoints", output
  end
end