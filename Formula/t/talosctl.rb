class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://ghfast.top/https://github.com/siderolabs/talos/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "457e8e7cdced8f022cd44bcabc69df66450033965d4cf0ee2bc737d9ab33c7f3"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be46e250fd2d61e1a95773dfd88d0a1776bd0dd6788a2be30ebb6d000e16819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4394307c22a9987c483ce37ea17ff716c08e3b4d57fc8f12d01ce930d05fa947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a0ced48ded6b6df68ee951d58ccd5ecf06c32ecfce08ff13aa82d4482764d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7d7f4259315dc4c2ea976e364407d0e4ca52cad2d0e73a3d662e0453e68154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09401601826675d16cfbe770fdc73ea8f23fb1be6fb5cee5d3d46c1660789a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11332fb470a92892bf7cb934048beaac96331ee19014bdfe2846f40e902b81b"
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