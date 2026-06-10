class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "d927b4ef81d5c05b97c304157057f342ae1a4aa88a8781497afab6b1e665c50a"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8771c8d1264e067ffa686f486d72663b3625425e2841065c991fa8fa2d9eeb03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8771c8d1264e067ffa686f486d72663b3625425e2841065c991fa8fa2d9eeb03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8771c8d1264e067ffa686f486d72663b3625425e2841065c991fa8fa2d9eeb03"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd1e5c63a25cabff7ff05d443910bf2bf3b6fdeb669912c783efc6c3e61c8b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8643c3a124393e6c48d511872bd7a7c6538b0ef8a7e755b99bbf7861c1df595a"
    sha256 cellar: :any,                 x86_64_linux:  "d9e3327f28d8466751c4f8e72d5b77da8c56905e39c9ec45606361c309b2c6d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
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