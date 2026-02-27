class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "8f7d45ed52c58b793aaec84cdb04474c2e99d57b04de6cc40dd16f90a68de305"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc277bb76141f3f9f08209a3378e02644825be13082b8fe7c6c737dcd139841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc277bb76141f3f9f08209a3378e02644825be13082b8fe7c6c737dcd139841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fc277bb76141f3f9f08209a3378e02644825be13082b8fe7c6c737dcd139841"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f0b5c92f94a99df2f90d45385f74a3c1336f07ae0fd49c7994ef39c10a2b0a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7078bdf6ded471facde22152dd5f93da3e46b2f90a154ef6928f3bb4db989403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7e19a41e5ef6b2dbbce40a7213db3b20d5d3d9dc79a2821fc7ad69a6116ecd"
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