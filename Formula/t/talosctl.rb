class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "1d8aecd624282ae0bf3be789bb8f95819d60cf5c4987523443d3ecd5bf1072a2"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b01d898b12b05e789d77db49930d06c372d22d20760425bf810b6b511cf6c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f167c440472467f4015fca1d0296eccaf9098158be9c4ac83906995e1b0fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f99f59b422192e4a7fedb156bbc6d70a828968ed61e5ec511a5984e61cd30862"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac6faa39bfd6d2aabf49c4337f19cd287da9d07900a688c9e7822ddc9eda904"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc49e9e91d466542a9ff46d0428e5831135cb33291381731f6a565a6ca04d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f107670420c4a197faaabae09f7d271a9dc9e0ed23766146cec6d3738c50a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61c28be43de250b6d604baf2e2103447af8b7e708f70ae47d321b44bd4fd4b2"
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