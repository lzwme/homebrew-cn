class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "c2c30bdfebb19b1be2901fe00e03c4cd8d80c2a2287325b4ffdf8b996e6de571"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9da8e76ed439355820d12e93f4fc4d716ee45763143997af045ef31fe378bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9da8e76ed439355820d12e93f4fc4d716ee45763143997af045ef31fe378bf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9da8e76ed439355820d12e93f4fc4d716ee45763143997af045ef31fe378bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3bc60924397a07dd743099697f3cabd9f7dfaaebe8018ba55a86de5b9c6f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332890e939adcc81642ca42d6bc36cb5a4907c00e6b589733efcd9d5c23a55af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd884413cad7fc921b52077c0f04533ba39bba2e38ab333ddb3135db0da8ea0a"
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