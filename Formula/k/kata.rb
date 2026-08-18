class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://ghfast.top/https://github.com/kenn-io/kata/releases/download/v0.15.0/kata_0.15.0_source.tar.gz"
  sha256 "8ad56ae9987fe8450e27343f8241f61951916e59219be1f9b5d87fa42ea96cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee9c439830558829256d7377d8896504068dd05d4e5d1c8643c78e477681447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee9c439830558829256d7377d8896504068dd05d4e5d1c8643c78e477681447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee9c439830558829256d7377d8896504068dd05d4e5d1c8643c78e477681447"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a3c906d337cc60d38333579ff23ad5dacc79da827ad652439c29eb5ef9c847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc586982d7a7492e6a0559746930776c19b1e94a1bf72bf2e126709d1bcdbde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28f1787cb8a17cba71274f3c7abb00445160d080c5401dda9cb2b58b79b8d6e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X go.kenn.io/kata/internal/version.Version=v#{version}
      -X go.kenn.io/kata/internal/version.Distribution=homebrew
      -X go.kenn.io/kata/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor", "-buildvcs=false", "./cmd/kata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kata version")

    ENV["KATA_HOME"] = testpath/"kata-home"
    ENV["KATA_TELEMETRY_ENABLED"] = "0"
    begin
      system bin/"kata", "init", "--project", "homebrew-test"
      system bin/"kata", "create", "Homebrew test issue"
      assert_match "Homebrew test issue", shell_output("#{bin}/kata list")
    ensure
      system bin/"kata", "daemon", "stop"
    end
  end
end