class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a4a3299cbbcecd2db2f7faf6289f9f3c653a3bddfb276daa12eb5481d7be654b"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb774e3cc1e0654e5877c1401659215a4da38c372ce5b7c757b9f32ff9ad4ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb774e3cc1e0654e5877c1401659215a4da38c372ce5b7c757b9f32ff9ad4ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb774e3cc1e0654e5877c1401659215a4da38c372ce5b7c757b9f32ff9ad4ba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68e1798cb945c5a501226f337a26055e745bb96980c2cb7fcd48115f21d73f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0259983bed3260247d02408a48ab30e81f8ad3f3e9a70857d9cf8b68e69791da"
    sha256 cellar: :any,                 x86_64_linux:  "073a715c5431ae025ba4af1196dfebd6b0e18cebcbd978d12bb975ce9f675f4e"
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