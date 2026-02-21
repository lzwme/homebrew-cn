class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghfast.top/https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "fa3472a765b031636ba79efdd1068012794a5a83679364136d456fcde0519fa3"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7d1541b4d0bbecc9df608d4b53153d02ab6a8a9873c0d7ee578f0946dd7866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed7d1541b4d0bbecc9df608d4b53153d02ab6a8a9873c0d7ee578f0946dd7866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed7d1541b4d0bbecc9df608d4b53153d02ab6a8a9873c0d7ee578f0946dd7866"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac3509f522acdf8149cdbe7242fc9b0fd38c03268ff557f88c966094f96e1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2caa5d7ac64bd3c72554f0e48764eb36659e06e2d4896d97d1c34cc2dbeabea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "199dee8968b3f43ce7b9dd5c044f18cc7c9a4f6ce52a96b99077afd3e18f0c9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end