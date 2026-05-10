class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "80e083482c045085b6731a365ef2d12b7690549449469b72a32b03f59608c2d5"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aba375b7cd0c54f08f9b6b2eba9ee0f0c91480bfcd007df35515a07db2b3d7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aba375b7cd0c54f08f9b6b2eba9ee0f0c91480bfcd007df35515a07db2b3d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aba375b7cd0c54f08f9b6b2eba9ee0f0c91480bfcd007df35515a07db2b3d7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6222e1fc8d5704a946f086b4f156258cf1b7043cb255861fc634febee9b8a148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "378400d45f2a507112a649055aa7a1a0fbfc6a70b1a2c9e37fc46a0db995e286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc958ac469a25714e80ac029a8fac8635e74d927841dbcd91b66371049114d67"
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