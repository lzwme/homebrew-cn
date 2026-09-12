class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://ghfast.top/https://github.com/kenn-io/kata/releases/download/v0.17.2/kata_0.17.2_source.tar.gz"
  sha256 "4ce3161dac6b390750713800af4dd0b21b42a18c49683b93ee1bf9b064edb6ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc445f2f682ef771fc360f2ef9f6983edf5edc10a2ed38cb98dde6a035864904"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc445f2f682ef771fc360f2ef9f6983edf5edc10a2ed38cb98dde6a035864904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc445f2f682ef771fc360f2ef9f6983edf5edc10a2ed38cb98dde6a035864904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fc445f2f682ef771fc360f2ef9f6983edf5edc10a2ed38cb98dde6a035864904"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64eccb559d488e3ce7167c8fd7d1289d2973b9670030839f70ce2d62f2ac4301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "35aba27614f8d55c86298e5e65ebcb2075a00cd1010618432fa66acfdc404f91"
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