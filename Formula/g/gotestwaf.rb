class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.5.1.tar.gz"
  sha256 "fca75bae227b72304e665ea4984d3508463a542ed5d0e3afea1e8732c3e7651a"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1b6968a4f80a2c5e5284cba4f7e4c49fc7feeb52ef52024330d65b6b942044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ca0b4a7efc63fc151757565d3f9f544241b91f0a126f46f686ef6e5433922ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8ccfec7bf480f6edb4c160a2a18f8f34f9c68c0e5314689deef39074be25b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bdc48321aac1deaa28d1be6327e9a9bea5ccd3d5354ed218b288a68394a10fd"
    sha256 cellar: :any_skip_relocation, ventura:        "38ec2b06df6a85dd476f1d7870edce25310811e89b1f47b1db7623bc5da38fff"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cfa5f3aa4b6caae54f84437dba86322f4f89b28ebe273ebfec57721544a876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8eb924de61163248390baf9c3c7313bb3fac0e44ad1916a60cbeb40da310dd9"
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