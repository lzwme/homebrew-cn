class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5ab887f79359335cb58fbfc9999616f33567a9c5487ccea411ddb3900fe36694"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d457aa80fe401df71bba8744f9f5a1a8506f5b8d71b81717a50c8e36169bd3fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d457aa80fe401df71bba8744f9f5a1a8506f5b8d71b81717a50c8e36169bd3fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d457aa80fe401df71bba8744f9f5a1a8506f5b8d71b81717a50c8e36169bd3fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ab70f69f46cc6e89191f02eedaa7b62fc92b3ed9813c3070f02fd0cab86637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5353251624dd0319abf0dee517d38b08454d1f67c73256240259b81eafb05c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a84df63721aa77e9cdabf5f3a08b8397584c3c86f740632e9145f20216216f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    ENV["HOME"] = testpath
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    review = (testpath/".crit/review.json").read
    assert_match "looks good", review
    assert_match "hello.md", review
  end
end