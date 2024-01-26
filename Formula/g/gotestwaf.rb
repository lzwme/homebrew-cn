class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.4.10.tar.gz"
  sha256 "a0e49babc36d98234fcbf0ee58485290824ab41f7a8fc35a148995c5e83d8e7b"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04770a205f97fe819541468d11e8d4e2b9b072c405e2447469f861a9dd0880fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c9bb9f81e50e65d5ed1ecb8e14f36b9dd428581d1e31ced806d15122302897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9fb033cb748166d8eb91ef7f76f563229d028b0ee57acfd2909fb15b43462d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cfd727198276ad27373dbeba12e36701848d93bdd1119939d2dd630907ec289"
    sha256 cellar: :any_skip_relocation, ventura:        "87689d4d6d982dc1593ba51f64c7e5b74c0fcf447bea12d3998c3f1d5da64fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb9c4844307819d101a3ff3f580cb5094cd146e4f9be80602cfbd4c94ed08ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce0b9198570f25c64277cb38c32b7a1f2ee98c791c1b1cef107ce1b3236985f"
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