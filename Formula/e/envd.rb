class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghfast.top/https://github.com/tensorchord/envd/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "755cc5a14622f4094e3df944eeaeaf53251ecc59a9d74e386cb7bdbe496a9366"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4177e7aaa1042c994ee52caad00736815599a9a1ad6acb47d3a48094d50da97b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da1950ccc93011216a4b4f9f43a3d1ff5b91affd829cdb660642b508b0da2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ff71edee0e518f4c03205a36be9b87c91c1a542c6b6057577d9d749c56eb06"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5a2e950350ed5062a323c9e2a15d1491edbc948c7da77afc1096dd635cd3849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5552b7f9a7df500c605453bf4ecffa4b41761b7667a9d7ca0363dd78c6eee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c3b235048c112ce9ceac168f6ca589d7fbc829b83bfa9487414725f923fe7e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end