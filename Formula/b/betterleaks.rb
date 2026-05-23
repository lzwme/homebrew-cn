class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c2994ebc253010eae1b0131677a12759fdfb756873180be07bd81d0420f1430c"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2852c86221da97f4e72794f4eb355286eed9aa18d330d86853c0431a2c4d62c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2852c86221da97f4e72794f4eb355286eed9aa18d330d86853c0431a2c4d62c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2852c86221da97f4e72794f4eb355286eed9aa18d330d86853c0431a2c4d62c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c105b75b84fcaeb8498f80a2385e4caf6ae81cfc6e477c849a6cefb59c8e4ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f9c1401c642ad0f8ce4326967fa4c491ec71e2752b095d23870029463082cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab197eb929e08f58c5a8ccef4d0e26dbaa8ca6fe8487951862a2acabfb6feb1"
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