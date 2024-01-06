class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.48.2.tar.gz"
  sha256 "1ddb610d9c2bcd10cc5b22988196b470cc6b43198efa1bd5a13bb3ed20c202de"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9610edf9668380938e41c9975db6a0d0a9cee5891c2496cb265e56ca2316e2b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e454af57f90c41f08f09294c48ff5d8c32cfca6da2491e7256b6607d819a7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93150b0e90676cb1ac4f74a6a2e8c03818674437b6f19d791f1b305169d63008"
    sha256 cellar: :any_skip_relocation, sonoma:         "04707c644117a9571957e82fbc990b8919b1c7aa3809877914dc4e8878d34e37"
    sha256 cellar: :any_skip_relocation, ventura:        "d67ad626288a69056be0f928db28015e770b00b933a68449a864c2b8b5bfcad5"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f1c6a4425e9c8d560502860a5c918c2e242c08d213dff9c2f13ffe80896291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c554b22221e80746af688360a6f6484b0d6e17a16d4bbd015418b39c7d10d333"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversion.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end