class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "10b6ce1a5ae1f029043662a73d51d1aacce5c379e0c8504752f68ea38214a1eb"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97401ad30b3cdbcace0cb445a4d89e91748e9cdb87b3b2992a85d8faf063f860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97401ad30b3cdbcace0cb445a4d89e91748e9cdb87b3b2992a85d8faf063f860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97401ad30b3cdbcace0cb445a4d89e91748e9cdb87b3b2992a85d8faf063f860"
    sha256 cellar: :any_skip_relocation, sonoma:        "c084460b7a736040666680328e438f963ca6c613da4e758a2eda80b7fa4d0658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2dadfe99c22e7a8adc05e19424174062e70ce2d733ce17741dab1c1f282ef4c"
    sha256 cellar: :any,                 x86_64_linux:  "cabd89b529c1706fbd1435c80720f65b77fe63fe5f65e027056e91402544edbc"
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