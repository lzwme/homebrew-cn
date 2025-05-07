class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:trivy.dev"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.62.1.tar.gz"
  sha256 "1b8000f08876dd02203021414581275daa69db00fab731351dbcf2a008ebe82a"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e742f9af9ff0d46d6d774403472783ec7975eead80449d0eebac8209595bcc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8011b49c51ab423f588157e71a4b639929551d2d40f7806a56b674f340b58d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93f7f3555004dc551ff906eafc17cb5bc8b66dfe556f7ca3505e72192e114bd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd35dab2279487b64edeced48c62f82883092ce5adf933e9c569872fc400d0bb"
    sha256 cellar: :any_skip_relocation, ventura:       "89990ebb9a19a94b07bb357e43a9ccadf2585ad298bf3b1d561f61816ea5db6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8204027f4128fde5ff14c5c0269c7b7803457a5b05e0a9b5d26ad4ef07d22c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cde021dbb3e8ad0c1be8cbc9a249c04a41c5f5673c490a9fb6095d30a5af40"
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