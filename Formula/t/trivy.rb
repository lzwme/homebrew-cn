class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.53.0.tar.gz"
  sha256 "958a5f2ea846f102ca14d3c0627b04117f85c5b35b30ac68119184d13faa791e"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d0c2aa4b33b8c49145d2bcfecb229942cd39811b9aa2190d1f3c33bdddbf37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b625288030eb1d78db8160af257804bb616f90e756f8dfea8fd9876be395c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e86cd96218a2252a4d631b8e497f13db33f5b8ce03f31613f690853ea5c0cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d182bf75aed0cf4e8871fd016018655336879fac144f404c9126d18474261de4"
    sha256 cellar: :any_skip_relocation, ventura:        "ddbe03f511f8fd3a821a93913432fa2ea41b4d04296e8af27c74184328cf7261"
    sha256 cellar: :any_skip_relocation, monterey:       "09b00845a16ac562e798a78b04b3796cbeed82fbb7d611f484ac0262cf018fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a678633c7ef89ca1465449a7fe880e77c20b0775505670a1f7afba3b62884ef9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end