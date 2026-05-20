class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "bfe57204e200744f5dd869cc07bae90e19253160e52de1f5453ce487e44ffc00"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b3ae2d9d19c53556e23004714fdb1b7fe77c4fe244e7f2085fb6f48f783a0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b3ae2d9d19c53556e23004714fdb1b7fe77c4fe244e7f2085fb6f48f783a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b3ae2d9d19c53556e23004714fdb1b7fe77c4fe244e7f2085fb6f48f783a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c827d3e5a0647d13910735b70d18d9cb0703910495568407babc4a1a2304bbad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611eef645cc91e930af0274f979b5598e9c27de90e8c9984005002b48cd189ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e820d0ad5fb742d2195a3095b84f32ef4a481cc2a4e48a7761175bcbc8b18ed"
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