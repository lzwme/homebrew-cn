class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.14.4.tar.gz"
  sha256 "c7ef2fc1bd003e17cb6f4044892fcaba820c2a50837b16edda067a8aa6f58d73"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8aa6742657bf8cfcb1734a94d036c6a350bd9c489ff33151ea267e12bbfdb65"
    sha256 cellar: :any_skip_relocation, ventura:       "d8aa6742657bf8cfcb1734a94d036c6a350bd9c489ff33151ea267e12bbfdb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384c295bfd719f37599329389ec61307fa0bf3aac6989b8421acd14c3e19be54"
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