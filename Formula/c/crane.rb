class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https:github.comgooglego-containerregistry"
  url "https:github.comgooglego-containerregistryarchiverefstagsv0.20.4.tar.gz"
  sha256 "4d2db32f704178af0c1cf52494cbafc4ace158c8afbfc1e9126ee9a719bc7425"
  license "Apache-2.0"
  head "https:github.comgooglego-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83537a813e9ab551c57d5b1886c5e6eec9ee9f45a3c297f32d859a859f264fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83537a813e9ab551c57d5b1886c5e6eec9ee9f45a3c297f32d859a859f264fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83537a813e9ab551c57d5b1886c5e6eec9ee9f45a3c297f32d859a859f264fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ef0bfa3027a09b219c21e4c00883532dd5d417350e04dccd2723d36fbfbdbb"
    sha256 cellar: :any_skip_relocation, ventura:       "c0ef0bfa3027a09b219c21e4c00883532dd5d417350e04dccd2723d36fbfbdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa9def22a2e7bbb9bc148d5530436331de1d646acaafcc693ad9f8a6688aadc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgooglego-containerregistrycmdcranecmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdcrane"

    generate_completions_from_executable(bin"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}crane manifest gcr.iogo-containerregistrycrane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end