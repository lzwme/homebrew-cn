class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.56.1.tar.gz"
  sha256 "e117413607450c4194c08947a9f65c5ae039f7a84b71e6f236dcd70b0b2de7a5"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c241ffe87c60376ffe7788cb9993a3fbf5a65f78bc6e48e2e11cf0ea990458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd48cfaba80250d3ae58fff1a301f3f153d832600318f6145d9d4fedc03bb2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32ec0535a046175f1f500113c79ce4cdb5f879d968a9417cac7850f514d01d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "79abaa7e4936223256f89a910d887e9efa4db03c74fe804ec20b05f4242117f0"
    sha256 cellar: :any_skip_relocation, ventura:       "179dc7e81ae8ee39cd977671a96e63693403576ca0d3c4e19aa13d4192854d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5453ce919c79308e42fffaa2566f4851f8527f31c4630196d4b8b6a120adf0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end