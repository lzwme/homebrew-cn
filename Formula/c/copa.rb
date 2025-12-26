class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://ghfast.top/https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "886aa760e9bdff174686d3c601cfb2f53e824299796ace3eef94dae03cdf15e1"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6cbd7985b6dd0af17d4e6401a79e845dfc97697072d1cf3381139c6d34c7529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6cbd7985b6dd0af17d4e6401a79e845dfc97697072d1cf3381139c6d34c7529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6cbd7985b6dd0af17d4e6401a79e845dfc97697072d1cf3381139c6d34c7529"
    sha256 cellar: :any_skip_relocation, sonoma:        "d98b13d9aef1764040a9c4b6d340ef7822bda738ae9c4b4bd27c5c367049da3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a966c3adc8bbaa46fdec8d0936508c8f2165f9356c3be67a1aebd848bb56a4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c25a12721b39bb7c7d4651ffe9240801d22d55ad884e27edb9961ec74cddd7e3"
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
    generate_completions_from_executable(bin/"copa", shell_parameter_format: :cobra)
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