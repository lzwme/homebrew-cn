class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.4.11.tar.gz"
  sha256 "3bfa72ddd848a3381e7ad9820eddd0e18447996c45e50abc64c5e278614b843d"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29beb07809e819738bc1df1f9fc92e849c01d7d98b816e0ba7bbc4e14cbd2a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2ddc30b5d14165a8825efb426086c53ed409ef7a4d72c4872d170c7091e3e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f398cd68cb387880c31c00c1383872934dc4748b7e666ff72c331531d9cf0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d69ad73b351890e74e0db853f8f4a1c0330880ee02d501175816c56ccb30667"
    sha256 cellar: :any_skip_relocation, ventura:        "a8b44f06b9811b06ee52d9992e33b21224b84591fe8cc4477a38ab7f75217032"
    sha256 cellar: :any_skip_relocation, monterey:       "a888c88a9554634a741068478b14db3a114a26c688d499527557d7b708d4e065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5016a30d689f2ea9e036d438169b85ba5e4a3d90689277497fb22a2975252384"
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
    output = shell_output("#{bin}gotestwaf --url https:example.com 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}gotestwaf --version 2>&1")
  end
end