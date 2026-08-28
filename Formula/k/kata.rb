class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://ghfast.top/https://github.com/kenn-io/kata/releases/download/v0.16.0/kata_0.16.0_source.tar.gz"
  sha256 "f82f99998d6625119b49a0971aaee2518b472cc71d0658c663dbb86cb7f45d07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecf750c8d0c5e490dfd451515eec57f7e22fdea7d87a02829470d8ba8c0a1eba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf750c8d0c5e490dfd451515eec57f7e22fdea7d87a02829470d8ba8c0a1eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf750c8d0c5e490dfd451515eec57f7e22fdea7d87a02829470d8ba8c0a1eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f106c1636b980c2bfce5a4aa2a56a58d6bcbbbd45809480eb56c40c612054bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eefb444475f5debc46feb043a6710973bb555d6f142584c1f7c31c602565527"
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