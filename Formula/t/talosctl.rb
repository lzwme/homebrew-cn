class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "a6eca6410d5adaea158d4fca5d0bfd9a0f2c854e49517fd3c816ebafe4e846a4"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c2c2945f51f3160b973e364a596a72889d789637257ae3fb88d1a0baa34f461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1f7c0a2c57e1ae08e6c3414d5f7f81d97e3e0842eac7aabd8a59a1bb59f97d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2f2f38a0eb10663654f143a530f41a5e51a1bc7f931c323dbf3bd33a54aad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f90b0a29d7cb4e686c6527218f19d060620768ec238f6cf81864085579d50c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3145daa4d0102c95165918a507cb51345ed739998413b08ffb6b3ee5fb1af9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eba490d447387620a2c12bb41e713e5a7b9090cbf8dcb1ce3e60aeb24290f62"
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