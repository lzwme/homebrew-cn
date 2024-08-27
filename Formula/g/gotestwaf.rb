class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.5.4.tar.gz"
  sha256 "203e36c62c25a53a7a25524b66295eca6ab901d1d533712bd17b17d8a2c98abc"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8071c84b000a0a3f4bb833ae187dd451c2bae35bd5570d59823aa3c79571eed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8071c84b000a0a3f4bb833ae187dd451c2bae35bd5570d59823aa3c79571eed5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8071c84b000a0a3f4bb833ae187dd451c2bae35bd5570d59823aa3c79571eed5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef1cb35e2c02940aaa7aaea1bc74fe52bf807f506f9a71dbe118209c27628839"
    sha256 cellar: :any_skip_relocation, ventura:        "ef1cb35e2c02940aaa7aaea1bc74fe52bf807f506f9a71dbe118209c27628839"
    sha256 cellar: :any_skip_relocation, monterey:       "ef1cb35e2c02940aaa7aaea1bc74fe52bf807f506f9a71dbe118209c27628839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09d741ec91da74c9ef0ce986bc964c1c52c95c366cb9d6eeea845cdb2e4c98a"
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