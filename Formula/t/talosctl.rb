class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "55f82adbf65c1bb19f92b07f6bd706d6f7eef7597875ad517bc41cd78df424cb"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f63d605691c8066ec82ddd5dd7fc20b2f95966cb8258bad195343c35db53561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6646a9ee34a7ca185e53ac05a0b662ed8be071ab99741f0370499c9c6fd6a208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ecb1fa4447871cdd2adeb6d0c7f93ffd2995241d925a45b914f68da626a8c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e3083287b7f1c349c59f38b862ce009151905a2f4ba923f2d5ff1a82e203ee"
    sha256 cellar: :any_skip_relocation, ventura:       "8768d81656d47fc666667cc723240bd85a3463a092e113a3a09f06b954177766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795e1757955cab12e6fda1f0a9f88c0bbfc559b512fc509c9db9133360add257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895421b9cf38151c991d8f16a33cfaa10c21cd69d9b0e08dfe7e147e8093c6f2"
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