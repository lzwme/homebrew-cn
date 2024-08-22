class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.5.3.tar.gz"
  sha256 "f6bc66dd066e7e6c4fd5ca091b05d8db645ffb3e5b4cc7e33040e1d99b2bf467"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d43fb413ec4241db89aa4f02044f0d073a584a16dccc6f0c08f8df86b1adc5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43fb413ec4241db89aa4f02044f0d073a584a16dccc6f0c08f8df86b1adc5c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43fb413ec4241db89aa4f02044f0d073a584a16dccc6f0c08f8df86b1adc5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "41890b311cf5c3d0c57a6bb5ee8e3001a450a77dfcae92d35a5cd6721bd7f892"
    sha256 cellar: :any_skip_relocation, ventura:        "41890b311cf5c3d0c57a6bb5ee8e3001a450a77dfcae92d35a5cd6721bd7f892"
    sha256 cellar: :any_skip_relocation, monterey:       "41890b311cf5c3d0c57a6bb5ee8e3001a450a77dfcae92d35a5cd6721bd7f892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb0ee9b6affd7a82871fdbb16e479d152e5178f81e6fb4a96e8b65bf1f924e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comwallarmgotestwafinternalversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgotestwaf"

    pkgetc.install "config.yaml"
  end

  test do
    cp pkgetc"config.yaml", testpath

    (testpath"testcasessql-injectiontest.yaml").write <<~EOS
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

    output = shell_output("#{bin}gotestwaf --noEmailReport --url https:example.com 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}gotestwaf --version 2>&1")
  end
end