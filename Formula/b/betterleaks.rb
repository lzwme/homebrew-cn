class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://ghfast.top/https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a3df6a7a21bef08684896271b7e25284299c678804be5cad682a8d56745b422e"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbd14dc8c8f3cc1f0e461246c68f146c05abb25a88d6a9395b4ef8b57b36bd41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd14dc8c8f3cc1f0e461246c68f146c05abb25a88d6a9395b4ef8b57b36bd41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd14dc8c8f3cc1f0e461246c68f146c05abb25a88d6a9395b4ef8b57b36bd41"
    sha256 cellar: :any_skip_relocation, sonoma:        "80bbb5b7424e446a6f5dfcf76fe9d8f7a60d6bb2b58262a21a5b9e473d4fcb93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20feb94703c87de7ff38c8a94971230f3eade8addcd6622d38225c458f882db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af6651cfa349ea60100048a806ccb1938baa66ee3cfe00a407c8fb1fa27cd98"
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