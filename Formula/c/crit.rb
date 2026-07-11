class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "29e7d262282f7e6a7b4efbf4d0b43a738333370d07df67f6f5be944752f4be6d"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d484d7ddcb99a8ea95b35ad44cf4a1ae7aa26fd9d6956cb03f5e8561502de29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d484d7ddcb99a8ea95b35ad44cf4a1ae7aa26fd9d6956cb03f5e8561502de29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d484d7ddcb99a8ea95b35ad44cf4a1ae7aa26fd9d6956cb03f5e8561502de29"
    sha256 cellar: :any_skip_relocation, sonoma:        "498b7a0dd2987deb919c898a0c8e11e2580c0a1bbcb3b98c833b844e5c696031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42f10a95a3e03198bf1478b5e2fe124944823603e7da85d14a176a68edd6de5d"
    sha256 cellar: :any,                 x86_64_linux:  "91d105a5514901dd396a5e449c6b9c599d4c09502d34c9f6a2166d911fd0a2a9"
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