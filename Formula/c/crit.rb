class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7672556b579e6b8ce1d4f6f3c921872d4cd346287bf379df222b9813c0c732a3"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c279c641363aa67452170612c5f59c66e6f6b4e6081b114320e495781018aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9c279c641363aa67452170612c5f59c66e6f6b4e6081b114320e495781018aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c279c641363aa67452170612c5f59c66e6f6b4e6081b114320e495781018aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c9765d11b5e105f0ea88705f69cff6437362ca283805bd79f564ff542ebe7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d055e624fad938dc52f8f45e811bafffce07d9a4ce52f434f61afd9113a4bbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1296e8c668429bfc49971371d88f305122187c93c9ccb1c628488bc810c06f32"
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