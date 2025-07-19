class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://ghfast.top/https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "0780607d4a9e090d6be50d9e356e8b6e8065e2639b0462b6b8d1892db2b61d0d"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "480abc79bea67bd74b27fd45c33825070abb7479b1d2e0f0d0e1fb8fe516afb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480abc79bea67bd74b27fd45c33825070abb7479b1d2e0f0d0e1fb8fe516afb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "480abc79bea67bd74b27fd45c33825070abb7479b1d2e0f0d0e1fb8fe516afb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3288f5c98a0c178a2c46bb85b5f85a2a5722b9cb72b5eb327525b2bddd9e5c"
    sha256 cellar: :any_skip_relocation, ventura:       "ef3288f5c98a0c178a2c46bb85b5f85a2a5722b9cb72b5eb327525b2bddd9e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94f17147ccab9311190e22aa08e2fefa33452c871f86210f9c38802ee7db0dd7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
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