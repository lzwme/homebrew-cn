class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "380be39a238c9b9ece1c3e0ac073279a97cdb0f738b5c7d7733214699d48f2cd"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d483bb450a50f061514aa29e0975f8d291fefe64b510d24c113a3d3e7b1dfc18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d483bb450a50f061514aa29e0975f8d291fefe64b510d24c113a3d3e7b1dfc18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d483bb450a50f061514aa29e0975f8d291fefe64b510d24c113a3d3e7b1dfc18"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d400b3d1e1ce92148083aaa5af9f488114bf436ca3485e0124d3de9ca67425c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7598ad78550a3079e577367e39a353dd55bdbe230e9b107fe8096c96861a9bc7"
    sha256 cellar: :any,                 x86_64_linux:  "1d4016c50589df88a3fc4fff549a54d1f9eca824fdf5a9f68f7db2743a89f3ad"
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