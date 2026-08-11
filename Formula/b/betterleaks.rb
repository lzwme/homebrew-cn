class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "6bd5a951513e6077f14bddf41f44c1a6d9cf1850bd59507182bcfdbb8effa747"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8422b101f66a31f7cc869e8a3186669620ba5736b9e63380a4136c6fc5e2b832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8422b101f66a31f7cc869e8a3186669620ba5736b9e63380a4136c6fc5e2b832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8422b101f66a31f7cc869e8a3186669620ba5736b9e63380a4136c6fc5e2b832"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd4de6b6bd8cc0138b5fb0945e99e9c9a285682af02c7d9f176ddbd2588dbbfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a1beef4906d711f1050e1b3f0539088ca296a97be73d09dab57caa0ea55613"
    sha256 cellar: :any,                 x86_64_linux:  "4486bfd0838558810efc5c8d863f2a63a362c498006b985c41a6d87a707d554b"
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