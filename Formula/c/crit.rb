class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "f720e4266a9e95a48d1201224338795fed7b1520dbd4400ee2ea0200bfa3cc72"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6148b64bea23ecdaa28d63ba9acbb9b9747ec062e032acecd37364d917a8b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6148b64bea23ecdaa28d63ba9acbb9b9747ec062e032acecd37364d917a8b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6148b64bea23ecdaa28d63ba9acbb9b9747ec062e032acecd37364d917a8b43"
    sha256 cellar: :any_skip_relocation, sonoma:        "651c7741e362c00d9ceda6681fe1df5288f27c5393dbba6608c57dfcd907b29d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22ce24d4ed56df04801b6f266670af20f93101b11a0339265edc8555cb7830b8"
    sha256 cellar: :any,                 x86_64_linux:  "9b70e9735677c31ed289b52914b308eb27976da4f158f3e1e69c551a983906c7"
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