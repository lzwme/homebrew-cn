class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "36fe9645bcbf5d9fc4d7feef9ef07d534ac0d0e8d9c12df4a4b67833ce97a9de"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d9def72da142df0a40250f2819a58d69b862c4f6808b1d4dbfe4aff23dc54e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9def72da142df0a40250f2819a58d69b862c4f6808b1d4dbfe4aff23dc54e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9def72da142df0a40250f2819a58d69b862c4f6808b1d4dbfe4aff23dc54e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2266c09656c48aa2ebef9c343f5d868052a05b924a6b9c33292c692725247489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1bc3964591e6dd1026bc60b43ec0f294e8e781379418844370f40488a23299e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359720455e289b5efaa47121d0c490037fee8f157f1ded07136d2858a8194be0"
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