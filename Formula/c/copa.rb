class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://ghfast.top/https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "886aa760e9bdff174686d3c601cfb2f53e824299796ace3eef94dae03cdf15e1"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "635dacdab4c4c423d2756d4339b9dd3a39e4a8cd26b36fd835da42c4c16bb4d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635dacdab4c4c423d2756d4339b9dd3a39e4a8cd26b36fd835da42c4c16bb4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "635dacdab4c4c423d2756d4339b9dd3a39e4a8cd26b36fd835da42c4c16bb4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f5a3adf5c0a0185ece55991bcb596a487528039d9cc78757e1c43f7c64ed91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829abf9f91a4a3b6fe5bee50e6ac0fca53fb238d22ad7fb51ccb6f3da81a9a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b77a337f0c26a6e9f106a1eb4f5efd277aab77ff0c11a7cc78eeb959e25b3c6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/project-copacetic/copacetic/pkg/version.GitVersion=#{version}
      -X github.com/project-copacetic/copacetic/pkg/version.GitCommit=#{tap.user}
      -X github.com/project-copacetic/copacetic/pkg/version.BuildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"copa", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"report.json").write <<~JSON
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    JSON
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no patchable vulnerabilities found", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end