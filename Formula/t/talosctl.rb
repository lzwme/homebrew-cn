class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "618a31409f6c50b42dc0bc11117df9a12d68d5df452cc68fd1d22c0c2233b8a4"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee761ab12171140c96285a11188ab5ee3e46bf7bfb221dde2fff73c7f282f496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46a26543347120bf9106954b67490cbf29831029327ddcf52263ae25419f4e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8045ae6e295a8eeb550ea49b3a76e5f769cd562cec573e143e32f2d1fc3ddb47"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1bb4b13636be9df35655ef1ed38b5a7664c7e24216353af19aad7b32f3d2520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdaff91ad8b4aca46f1beda998953ccda3a56f763af1cc6e25dafb19d0554639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02bdcd8543667e424edd45a306f00e530bc276c5537090ba33c61781c872d30e"
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