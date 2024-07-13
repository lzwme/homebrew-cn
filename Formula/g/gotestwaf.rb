class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https:lab.wallarm.comtest-your-waf-before-hackers"
  url "https:github.comwallarmgotestwafarchiverefstagsv0.5.0.tar.gz"
  sha256 "d4813d56031748b1dee52a7cd02185fbd35a443cb78b036673fd789f8f7339fd"
  license "MIT"
  head "https:github.comwallarmgotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afd28e33a41c12e5a9ecad7cab3da88d40dcbdc2b861bfa70be8ce081f14e6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a11d0e2095c769386919220bc76c78c00a2ec7f1628b84461863fb6fda3d22c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634c7dd91cb44c47602139967a7b6e7d76a0506a9bccf32f64cbe916432e76e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "330ac843a227145b961a9ef2716a1de7e1a1d9c1e1953a8f64bb493854c1d437"
    sha256 cellar: :any_skip_relocation, ventura:        "ee592ca832a31dc3c9980e3f489102f2f6d8a07394176e79c42fd04c9800aae8"
    sha256 cellar: :any_skip_relocation, monterey:       "1e74dad0087085da2981613ec08e00799496933c6b4e48a697c3df5663c24fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef7418ce212ae60ea01b28f06f9ef611c5159af670840332b9b08ac9a2023280"
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