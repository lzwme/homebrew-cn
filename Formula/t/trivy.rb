class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.51.2.tar.gz"
  sha256 "b0e5e7b91114f2961e579852541bb0f99b3cc95a312a54833d2586a42e90b864"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b2c47c1beda167440e98c06e9c98f902e899c38586c9477899ef776f13ecd71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b17cb8a8d8eb85e382b8c55349b834134ed59013828049a87f8f81ddf19018b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f8a9e3d2d4e52dcf4e77ca2bc7796c0eb9023b4dcac7ae6d6846a1c7bbbc66"
    sha256 cellar: :any_skip_relocation, sonoma:         "9374d72e25a76652d175b0033d23a53fd30eb6d7ecd9d13a2e8e16cfa15e1441"
    sha256 cellar: :any_skip_relocation, ventura:        "e71a2671146c10ad918bcd68cdf4b5798aeb08bb68ebbb018f2d8416e14c430c"
    sha256 cellar: :any_skip_relocation, monterey:       "4950882aaeb720804e4493c3bac5f0a38336571942192503d7bd2f11e4c657ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8608d57458afb29228958f2592ac4468f2f258eb68beed81b3d5c38b637c02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversion.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end