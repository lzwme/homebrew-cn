class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghfast.top/https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "4b8a2c8a4c1955da7802806ea9437952e2c7f17f3dcf0362ac6c2f75388c389a"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afe54e46ae44c1a5a5ea600d3b114aacb0161d7e62625e01dc1ba645a672471f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe54e46ae44c1a5a5ea600d3b114aacb0161d7e62625e01dc1ba645a672471f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe54e46ae44c1a5a5ea600d3b114aacb0161d7e62625e01dc1ba645a672471f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e2f70f95fe1a1a19256a2b7d4c182ca8dbc2138eb3ea67c3b4dd18f21ec631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a7870bb77c80f31197918707d286f63cbdd2552444499ffb931c5c4f1d9f452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee232e2b59bbc12cd1e83a7611fdfe79bb481ecddbe981ff3abee9ce3e1ef2d"
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