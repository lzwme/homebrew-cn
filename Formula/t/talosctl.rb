class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "5489ac6a74fdb3e1ef80cdafab9c2fdc49cdb20a0ed4f8576b564d3698bd9e07"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ee7da6ce46fe9c0f4344bb9d6660cf3b8cb530d90ba69c69a6b33fd76372d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbd76799a9f3ff9c1cc99293600993c4113a1c4fffb989bb18041c6030c47cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88ea36de92d04560fd3cedd16c04c443d0759bf90d40f3c95c5a0c3aa8971989"
    sha256 cellar: :any_skip_relocation, sonoma:        "210bb2a3be0bf56e6552812a3cfb8373734e17c64eff59446c08d43fb00fd0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00eb53545240e76269a78b4381732116ed3483f69186c3170af63cafd0f8656b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7c6ee4f4ff6c1478ac562793d65db6226ac34c2f0494272a09f8ca7b3537d0"
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