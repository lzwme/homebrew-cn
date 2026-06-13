class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "fcb0c51c10d181a42c9d5db545f0c1b43f8b55b48e38b281fae3b04736e858f8"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b0b3f31d31451228315dd91eb4c41bdfe36e2df87949c7203e0ea408d86f429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0b3f31d31451228315dd91eb4c41bdfe36e2df87949c7203e0ea408d86f429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0b3f31d31451228315dd91eb4c41bdfe36e2df87949c7203e0ea408d86f429"
    sha256 cellar: :any_skip_relocation, sonoma:        "174e92d2d502ccf5aaf603b5c4572a2fd94994881c54286eb92ed61149c20c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8ed31c1f7d80fe0d53713bcdcdc19a9a3977be8f03bd34085b01e1746f28cd8"
    sha256 cellar: :any,                 x86_64_linux:  "9084cdfb644528245e91475fd06da60d6912e8b9eec67ba707d8ab5ba9cd5c75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/betterleaks/betterleaks/version.Version=#{version}"
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