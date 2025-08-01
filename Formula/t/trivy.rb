class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "45c31aa8b50955e440530ddf9a82fbea6ca6b388a2bcae5aa4dac157789667dc"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e0266828fe89c6dc7de5a87cc31dfa1f7423cb61fedff37694455193fe113e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "800b8d0ed73eb8a3d53a19032e343b79655a01105a51e5776a621467ff1774b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbe5b24d1b6316dea94525c491a0bb2580a0c712803797d8097c96ae3ae0900d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5b267b13a4424971c3056c0da47761929553cb2561b897ed8f760cbdbcdf604"
    sha256 cellar: :any_skip_relocation, ventura:       "cba31cda1d4ea4c9e16539a8d6a4e07d111bae34f5f06bcc0d5092afbd587de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae33e843d206abf99359bbff311d1d2820a745994da83fae90654ad4fbd76819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56172c47bb9e0afe9c029a0d14dcc193007d8240ae1457e82687e5834c29e446"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end