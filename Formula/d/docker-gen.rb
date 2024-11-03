class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.14.3.tar.gz"
  sha256 "90635588bdf7ffdd5875e4cc053066c5e348e94907d976e9d4298878d49ac587"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "870b1516a3fa982f14b281130e4c41cb2a6d3d461b58738f1e2697a50f96a973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "870b1516a3fa982f14b281130e4c41cb2a6d3d461b58738f1e2697a50f96a973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "870b1516a3fa982f14b281130e4c41cb2a6d3d461b58738f1e2697a50f96a973"
    sha256 cellar: :any_skip_relocation, sonoma:        "971b6a7a2d973e54a3a8e03145ad6d88ca453fc189f94b7ac92161ee27f6666e"
    sha256 cellar: :any_skip_relocation, ventura:       "971b6a7a2d973e54a3a8e03145ad6d88ca453fc189f94b7ac92161ee27f6666e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfc4d0bafc833a449655022a228810f77f6fa410d5f1e11f336d01cbb31daf1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmddocker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}docker-gen --version")
  end
end