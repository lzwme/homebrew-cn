class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "7359ae820c62c276d31cef3d1431eb8beb6db07d5c44830bad03dbe9c0cf3850"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fac761950752d436a9c55970a9cb55f3b4b6d36f54eda3222df0af4e16889c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fac761950752d436a9c55970a9cb55f3b4b6d36f54eda3222df0af4e16889c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fac761950752d436a9c55970a9cb55f3b4b6d36f54eda3222df0af4e16889c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae8b669138955cb78905a57d6e0c66f79d5a44d52d125bbe0513d76464567659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca229b4dba591e59264f9a80b6acd185ef27eefbef01656f36dc1aa0d934fff"
    sha256 cellar: :any,                 x86_64_linux:  "f1974e63d221e02490e40bcf200e8166a152114b85e8f5cac608c44958743637"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/betterleaks/betterleaks/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"betterleaks", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/betterleaks --version")

    (testpath/"betterleaks.toml").write <<~TOML
      title = "test-config"

      [[rules]]
      id = "custom-secret"
      regex = '''SECRET_[A-Z0-9]{8}'''
    TOML

    (testpath/"secrets.txt").write "prefix SECRET_ABC12345 suffix"

    report = testpath/"report.json"
    output = shell_output(
      "#{bin}/betterleaks dir --no-banner --log-level error " \
      "--config #{testpath}/betterleaks.toml " \
      "--report-format json --report-path #{report} #{testpath}/secrets.txt 2>&1",
      1,
    )
    assert_empty output

    findings = JSON.parse(report.read)
    assert_equal 1, findings.length
    assert_equal "custom-secret", findings.first["RuleID"]
  end
end