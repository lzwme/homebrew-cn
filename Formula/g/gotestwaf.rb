class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.4.13.tar.gz"
  sha256 "c49f33952eb0dac740d42e2d5559f0cfa000bc5c6d142fcd12e5675fc4673beb"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "293976f31688ed045cf175cd9a1fca94115b8e9e42ce491b9fb73938acde168a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1433818ac1eec945cc55bcaeb4626eb37e8a0e9fd7e95b24163a4f2962530d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf43d7db666bed2faaf66015367ca36da8ccb70484c5b4426957bb5855b1a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe47fae1effc09df5ccd50e6df052176cb29a37cf10d11053e48b0a903c65329"
    sha256 cellar: :any_skip_relocation, ventura:        "bac4631721fbd7ceec0e6db7423324d3b3f45304e33f2cb19a652c865f9a211b"
    sha256 cellar: :any_skip_relocation, monterey:       "c6aeeba6661ffadc7be30d564a7e6f0ab74bd04252e67d52dc9a42bce4dff5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d91ba59881210938e0261cc23edff21bb5742255e5d679d4c1a33af470a8a44"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comwallarmgotestwafinternalversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmd"

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