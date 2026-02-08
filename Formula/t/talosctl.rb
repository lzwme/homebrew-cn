class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "a025d5d74bc1b99c5ba9eae3ea8b80f02fcd825135bcefa1bef9785f44d7e9ac"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "280f3c63ba42c0c6acd2ab2da06d9e376c12d4bdeecde3aa4082a1a593506828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "459b72b10c9b53d1be9ec6340a44484266d22faad2fcc5bbed00ac82c7ac4ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0fc054d24bc0d6a4e209fe7892f6aa9c872d8ce3b0e7b6182b6fc67e9586991"
    sha256 cellar: :any_skip_relocation, sonoma:        "973da8546613b690bfa1e76359c82f59e7654e625c479f3da57252cd4a73d16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4164efbeb772b4836cbcbc68de5e1feb6a6bfba0339212f4cf97e98570d727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27901a538901d1c590d0c73bd8884f2637da12dfcafe396d10b6d2900f1c3810"
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