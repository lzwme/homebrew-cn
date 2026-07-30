class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "9c4895fe7b6fa32651bda47c19783ed5d7fb1be7b34eb08cdfc751d284301bbe"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0915d3de17f8bb8a814844e9836a11e44b94fd0d077bf0ad49dc9184484add5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0915d3de17f8bb8a814844e9836a11e44b94fd0d077bf0ad49dc9184484add5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0915d3de17f8bb8a814844e9836a11e44b94fd0d077bf0ad49dc9184484add5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9bd6605ddbcafff9073e915e21595148ab8dfdd0094c07edcc0431ec97ae726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92bcbadd2938ff0c9f40da8d1783786905445ee6ce7566fb79e3f7e9f39ad04e"
    sha256 cellar: :any,                 x86_64_linux:  "e5debb54a25b8ff924164f290479c7563ecc16cd88a5c118b860e39a1bec1e68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end