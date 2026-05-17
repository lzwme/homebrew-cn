class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3ce3024514340b613d67a65569aef7eebf02b417063bb61b31f37017dade2537"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e81457c2aa999da0795d7929bf91af6efaf0a37e63530092d1c7d8c2d6c3c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e81457c2aa999da0795d7929bf91af6efaf0a37e63530092d1c7d8c2d6c3c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e81457c2aa999da0795d7929bf91af6efaf0a37e63530092d1c7d8c2d6c3c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "69181bcfd0665073cd035c8da4a7c44ef313623d4d6015df680851e3ea1c2aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d3048bdcffbd1cbd00b0ab758c2c876a6180f23692a82b4bbce9d9867629fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f5c29047e73e752927299e02dc0f9ba3969161669c1029e885f92908ffb120"
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