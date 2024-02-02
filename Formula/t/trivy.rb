class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.49.0.tar.gz"
  sha256 "877569451890b87b21aa90a56942f45cff548d8293f120731cceabf93a539043"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82c5df4d1362fde5c42c6d53558040b12509b1e33a2cf49a2c817022821dcfad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772a4c3833f89b56d7152d8bca32f91000aebe5a35d43b2b48de2d28ad1d53c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de0f95b06dc814267970429913f06f924f4915d4680b2306b6539fe2e02ef33b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46a146117c6cd893f8245c9363ec5be65c50c20b44655d282d29a04b4bf7383"
    sha256 cellar: :any_skip_relocation, ventura:        "201383f7d8e4e6be11f7ab6ab47675f43dbac9077f9e5808c2efec65d58febb2"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf793a40cd21805cb2b490cb7ee062620bfd242a0d07db8f42b6183351edede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a85fc33115e14350c4737011780b6fe47188c1334dae54476c929ef08327b9d7"
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