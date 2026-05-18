class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "3b8a1c0db90ef337c51a9ad8618ffd315b3c0785645f14996dfd3841d0e495c8"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0e85a109912027f987a071e9ea7192f2e66237bd17d85dda7ab740bb311a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0e85a109912027f987a071e9ea7192f2e66237bd17d85dda7ab740bb311a08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0e85a109912027f987a071e9ea7192f2e66237bd17d85dda7ab740bb311a08"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b26da9b011274df63dd0f6d0ae500de0f5d9aedc83cca8a5440db040f62d840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ebdea2285f2a8ab1f51f15b3302417fda5fe609fdb09ccfd3d26a43f197ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3471645d87fb7ca45776d54ee86e79a3d0bc97f026d8ad42c8ac119708d8e27"
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