class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://ghproxy.com/https://github.com/cilium/hubble/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "46337c852e9bf981865d72803de3d32760e7c435b08a8ce30dbe1d6b9956bdca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c472537a1f34737aa005d90404b1277b676e395ab764eb36e5867d41707785fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c28ebdeb83941dfbe11c916c700d0adf121f5d92fbbe3c8fdad25cfc0a98f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f44912ba8dd5806007d0f5387f463abbce0bcb9c2e78d77fe5e61950437caf"
    sha256 cellar: :any_skip_relocation, ventura:        "cd380edb29da08c55094cd92dedf012ba29b000dc85e72754019d30b1e48b7d9"
    sha256 cellar: :any_skip_relocation, monterey:       "516cb35cfaff860d85e9cb0642101a23fbbdb6e88ea9df527a4d718561c66684"
    sha256 cellar: :any_skip_relocation, big_sur:        "471e6c3aa9d0244481b003671b6b5966e47114490d175240cf8f9382a5045928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a6c21ce129472fbc1b80a1b64bf83a96cc986e5ec3577cf6fd66ece5938fb69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end