class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:trivy.dev"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.64.0.tar.gz"
  sha256 "95f958c5cf46e063660c241d022a57f99309208c9725d6031b048c9c414ecfa7"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27c74bf7561f3232c0eef787e32be0360d93e686a812edaf7476951edfa329d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c414327af7c3247259b3ee8a277c138f79f5da638445e39415b8bd439b08f483"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbba574a1ec0c80ae50640b90a5894cbea4a31201bf4c2d86494a5f1e83d79dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "455dda78505e54b6e58b2fd650243b248e6c7c96dfef87839fe8a32d56ac145e"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ce96fdc00e223467e413910d6df7d33112cb9cbf602703e5485c6fa7eb842c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e1b6e79322751827633b975298257f0d38b8578531bf9925e5687e4442096c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e67ec811e89f0890b3753fe5eaec7093364160ee4cd015714c7467334c048d"
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