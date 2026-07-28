class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "5af3deef521c925d492aecbcf645b18d738afc348d3e729b4e209a78a7798934"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1c94d879c9579c05c094794931867d271aa9a9759ad3df29ca2570c2f67d387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c94d879c9579c05c094794931867d271aa9a9759ad3df29ca2570c2f67d387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c94d879c9579c05c094794931867d271aa9a9759ad3df29ca2570c2f67d387"
    sha256 cellar: :any_skip_relocation, sonoma:        "bafbf16271bbcd34c249b78809443521cc3b57b6a4cb6b9f480079162674cad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a93ea979f7ddb85daaff8b80f97b9fbad0c5be6e40e9d57a5d0d8aa1f861123"
    sha256 cellar: :any,                 x86_64_linux:  "25a0a559a36250b6ebd7a401812ee92483b76d30cf772c50a263338e1c0c22fc"
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