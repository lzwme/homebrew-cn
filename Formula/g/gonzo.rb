class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://ghfast.top/https://github.com/control-theory/gonzo/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "255564415e97322b80db29e947bd8de11699900b9389bfe82f5477973bc011a8"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7278b69a50a39290b1591c071cdb4545329bed2eb15672e4587e6c47d78e277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7278b69a50a39290b1591c071cdb4545329bed2eb15672e4587e6c47d78e277"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7278b69a50a39290b1591c071cdb4545329bed2eb15672e4587e6c47d78e277"
    sha256 cellar: :any_skip_relocation, sonoma:        "28399c3651c7680a6fa2b59f2f206829da51e64d7cd0137abc286df706d1c94e"
    sha256 cellar: :any_skip_relocation, ventura:       "28399c3651c7680a6fa2b59f2f206829da51e64d7cd0137abc286df706d1c94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4441b1f6f49ade64a091ddc1243e5a357cdcf2a576dcaf4553213a86f08fe380"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end