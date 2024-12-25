class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.58.1.tar.gz"
  sha256 "34149d223d37585d77f96d083c409eaefd31e9a9239217d731eb1ffa606c2d8d"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36abccb7b74255c252184607fe7da2a31df5db4d9ee80ce36d2f9f1c85878e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc4af815ca2c8bc6afe5c250d88a065e594da0c81ad3193044062f45d18368c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "205bf7983eafbec172e663818cac12e7e94a72ee33407a9fc7f5ec5b216bc593"
    sha256 cellar: :any_skip_relocation, sonoma:        "e23e6fe12f27f04b32e0628bbb160d9bfde05574cb47a451d8f400268cebe579"
    sha256 cellar: :any_skip_relocation, ventura:       "b987461fd039db2f9c13808f0611ea84861705a24ae6f15ae20cdbd9106e2ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e843db2f8ed574822f023178c61a58d46504172be8bca45a0aa7064e5b75f2c"
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