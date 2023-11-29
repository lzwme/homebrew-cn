class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://ghproxy.com/https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "03454eaddcf995306588c1e628e8f79ebafc4c99537c1f5d25d41489fb72205b"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "324b383156e5fc37e537e5460dcd38a54900ab4ba68e32849c3e9ce9097903cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5df153ae0e076071aafe57c15aa0f7ebfcad296390d0202564bf2f38463a5a3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11860c9ba9552f644fd80e482fd6d8316c62654a71b1aace8fdd0644d596c606"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9b6d52e4d171189bfb58b62dda837f57a795afb0ea22dbba7631d99c99106dc"
    sha256 cellar: :any_skip_relocation, ventura:        "2cff3afefb99cdf3515f2344478e346f545b3c02e761182cd15dd379a95bcbb2"
    sha256 cellar: :any_skip_relocation, monterey:       "ac834bbad6ce006f30a6c69807b5d678b78de293fae001cc36418395d84f4e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec08202d7b8c51a10e70185d4815b2734badc1126992a8f045ec0d489fd8dd2e"
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