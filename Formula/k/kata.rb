class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://ghfast.top/https://github.com/kenn-io/kata/releases/download/v0.14.3/kata_0.14.3_source.tar.gz"
  sha256 "1f3b0494ef57fa8ddd12ce22baeff323c820ee26598fba7a20fd5e5fe3a83c40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45f47edccf3dba53bc92b54ce9ef00825a8af9067b2ca0f947e887a134d9e204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f47edccf3dba53bc92b54ce9ef00825a8af9067b2ca0f947e887a134d9e204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f47edccf3dba53bc92b54ce9ef00825a8af9067b2ca0f947e887a134d9e204"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c18a025aed2bd2a16f42af9c38e95fd851bd5d5576ad4b01fb87c06a3030b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18a0c849de6697bcb07e5ef66482d9d32742696d517aeef3b2b1f914fe0e1543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567041b1bd76630a8615ec182e79d1abea2e99fc689748bf6b37f29c6b555b8d"
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