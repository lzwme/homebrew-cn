class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.13.1.tar.gz"
  sha256 "5decda95409533316ae20716e9720bbf4cbf2f4c4df6b96186428636b704ce45"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fbffe1b582a0f8b8833eeba83b0a9ca8fa0702202153fbb92d72518c04a0c67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c956b052793df748b3e37c90d26b3592350c598cb3d5175d445b142da80c356a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a4c7cfb7dd7f922ac6f371119ff89c1c1834e4ad06dca15617819f9a1f93c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d71386f7a9beac68601c9edc33fed870cfc03b229013e30dd5d5b590f2b12d3"
    sha256 cellar: :any_skip_relocation, ventura:        "70d4a12cc09879b8d3211e0829b37880c99c879e810c1ab57c353f7394f1d47b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e2762afab6bc19a16713b4e0785fa5d4f7ba593d10f6de80083c2291ddbac21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5388f52348dff4a50a6c14f56107a3da823bb35f22961417efa1f053aa82a0e"
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