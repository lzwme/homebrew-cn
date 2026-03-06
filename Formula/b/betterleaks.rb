class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1f02b1967b5194eafe0c1d713c6aab9b8f81257fadc8d51e94ff15352ffc40b4"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262f03847d487830a55df9bc3d6c34a0bfdff79ba69c6985d6fe5488d1fb6cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262f03847d487830a55df9bc3d6c34a0bfdff79ba69c6985d6fe5488d1fb6cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262f03847d487830a55df9bc3d6c34a0bfdff79ba69c6985d6fe5488d1fb6cbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "90233cdc741b779dcc6fced08544c6a9ca062b759857e3ffd3f8bcaa5bd4a33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "440a5057db09dbed6254c27bcfb0cb78277eee3d9c232161b9d180481f72ef85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f23243a3391c935d453f87748bb87ccb9e30fa623982cfd7d018b6ea51fd72"
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