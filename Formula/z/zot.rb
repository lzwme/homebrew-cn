class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.46.tar.gz"
  sha256 "38cfff0827e9dc2ea11c30edfddcbe178c76629f695b254150d91f403112d641"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb49ee58091d09e428e2660980d5463cfd42d49f26e80e121735dbf0e7e818c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb49ee58091d09e428e2660980d5463cfd42d49f26e80e121735dbf0e7e818c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb49ee58091d09e428e2660980d5463cfd42d49f26e80e121735dbf0e7e818c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e9ef38e94ae29c67e8edaffffa1abdd4aaa9ecbee973872d6b3f3c474ec144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d86164b7dcaaff65c78a861551cab9e746f0afd34b9a2dee3a97976a9bab9f"
    sha256 cellar: :any,                 x86_64_linux:  "cc38bcf9e7203f3b0036c62d37b69a953e762433838c63d110a297368e1aaf07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end