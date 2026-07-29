class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "686b4f607f03838e0f98448c62627334ecc595762d7b3512df6bdeaeff68ff4d"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "849220bd0eda9f99b937268b44b87dc1711546d036cfbc4df2ab346796cfed4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849220bd0eda9f99b937268b44b87dc1711546d036cfbc4df2ab346796cfed4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849220bd0eda9f99b937268b44b87dc1711546d036cfbc4df2ab346796cfed4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9d351e44de7e4a0119a8073ee2e58d0364ac566ef2a409ce49b01c5121d66c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c4ea0e843b379d23ebd0b65b42cae58ed90f39a2bb1997ca04b06d9d4854fb"
    sha256 cellar: :any,                 x86_64_linux:  "cd40742077d94b9fdb8f8b05b36d295a47d74989cbb419a69f407d16dfef50a0"
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