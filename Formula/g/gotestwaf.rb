class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://ghproxy.com/https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "538fc530328da602bfc3b8b0d5b36fe536fe83e2bdb1c6f44bcf05b45a3f3c56"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "328aac2036780842950bfabc6712d0870134b2d0c12e33fe6d761d7ba3f3cae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a52e8e05211e48b5c1888b026c0d21899e1559ba3e907533adb6e82611e3ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c769910f8b806d364a2cad2beb85c3a7918e31c5b1aaaa1d79f751887b640e"
    sha256 cellar: :any_skip_relocation, sonoma:         "862b88876a7c1e94f1e4f04598c5011b38f4feb423d322dbeaab9245d631a941"
    sha256 cellar: :any_skip_relocation, ventura:        "b7cff61b924fc20a788a0db0de5c21014f62b075d700cb4ab5eb06ec589d86d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1d58f8c5dd0aa2aa1be953bf19b33b99d01a56e206bb4455ce866f5e885ecd37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77dbb9bf6549e3fad9cc1a5b96f0dcad12298d4731d6ddde60606ca9e0eb5c42"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
    pkgetc.install "config.yaml"
  end

  test do
    cp pkgetc/"config.yaml", testpath
    (testpath/"testcases/sql-injection/test.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/gotestwaf --url https://example.com/ 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}/gotestwaf --version 2>&1")
  end
end