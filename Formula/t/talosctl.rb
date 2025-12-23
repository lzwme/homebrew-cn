class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "0e2a0396e171a0454288f079087591223278a78069c4e451006fa2415d447b1b"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ccfa5e97d421cbba1afafb2303221ec3f9fe86d2c428f6acb870f90dff88c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f911f1ae694358770f270844d1787f32db6cdce7d49cc04744d11358bfbb4d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898f33ecf9d0f9f230a8afd7af5fa4dd9a4e6eb4ab5957fdf81952161e74269e"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ede6f1e05ebf2e2bdfddf73172ea15465e24bef57bc4f58eb3550262bb04e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13ac498015c3e4a70b8590e83c8c06e6dfa4989a5313961be8b347d33e3738f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd6a56817d08ffc413f60d30e433a1faefb9cc3302a9b2d5bb03e2f30294eb2"
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