class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.57.1.tar.gz"
  sha256 "e9ff5b7a190e132180955a47e45007038816d9dca7e8ded96008d90fa79323e2"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6194bb14e1871d97ad6ff68c887e994f4d9ea01d4ae461740e2fecf1f3b8b590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d855edb61377fe885bb8866bd8f4aec1792e0b250f2f37d6db964b972a9935"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f56a934612fd7577afdd81de94abccbbfa8304f5d3f7e466492bfdfc656f07d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ff89cfe14b3c1481e191f62a06c1416127309108da2e215c88e520eeb60fa1"
    sha256 cellar: :any_skip_relocation, ventura:       "7140632abdc9e4d398c64ef1c829f8625b9882d51c6f7ae9758d17e53fe9e2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6279f528df0fee119f4161796006d6e2adc2d49e3deae856c70a476c923533"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]

    generate_completions_from_executable(bin"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end