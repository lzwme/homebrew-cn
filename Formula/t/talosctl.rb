class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "1d263dad011a6320db175e43a0483210d103c6f62714b3d21873fe81b93d2744"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14807fc90ac5b4a94f3e72c2f34deb9ed651941eaa983a695c82d90bbd94c0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02ff35718d03f04bc55f07390cd5714778e7d89632abac69b06dc8be9033260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b28dc7543c21114085432700f4a5623ba897ba13897f80f630b2d9b6dd91a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fc4ad16249cebca3b17d143a67bef8f9dc569339a375576b9af7fe79cc30207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c9c0b55a77c1d8d5df5806b8546041cd6a903322264e2d57789162d0673766d"
    sha256 cellar: :any,                 x86_64_linux:  "5f7705820010c86760f501d124718463dd026319f60d83a8ae38e8281bf6cc1c"
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