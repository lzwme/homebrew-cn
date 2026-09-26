class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://ghfast.top/https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "1e16260572ba1932014683b934d2f18df6c06aec960756d51eaedfe7e025a8c1"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e74cba58101dd2e91fec5aed201dae3b60c8c12df81e9436206fb9ef03a1b72f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e74cba58101dd2e91fec5aed201dae3b60c8c12df81e9436206fb9ef03a1b72f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e74cba58101dd2e91fec5aed201dae3b60c8c12df81e9436206fb9ef03a1b72f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "737e104725e902e5f7af41580c7f279033d14b301ce291cfa9cc8fca1b9510e4"
    sha256 cellar: :any,                 x86_64_linux:      "56ffc30b55f5005eefbcd3aab1a743fc638f042ee27c03f7ddc78f627ed7cc5f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotestwaf"

    pkgetc.install "config.yaml"
  end

  test do
    cp pkgetc/"config.yaml", testpath

    (testpath/"testcases/sql-injection/test.yaml").write <<~YAML
      ---
      payload:
        - '"union select -7431.1, name, @aaa from u_base--w-'
        - "'or 123.22=123.22"
        - "' waitfor delay '00:00:10'--"
        - "')) or pg_sleep(5)--"
      encoder:
        - Base64Flat
        - Url
      placeholder:
        - UrlPath
        - UrlParam
        - JsonBody
        - Header
    YAML

    output = shell_output("#{bin}/gotestwaf --noEmailReport --url https://example.com/ 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}/gotestwaf --version 2>&1")
  end
end