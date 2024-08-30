class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https:github.comsibprogrammerxq"
  url "https:github.comsibprogrammerxq.git",
      tag:      "v1.2.5",
      revision: "fb8ac87a3431cdfebeeda81053562e3aeebde6af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56adba6745dda15519f526ad670b2e4efbd2d716ac22cf3a3f472bd551e4808b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56adba6745dda15519f526ad670b2e4efbd2d716ac22cf3a3f472bd551e4808b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56adba6745dda15519f526ad670b2e4efbd2d716ac22cf3a3f472bd551e4808b"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb158b48cbbd3f0a451969192f713238797a3b1945f97743766151a27b9945c"
    sha256 cellar: :any_skip_relocation, ventura:        "feb158b48cbbd3f0a451969192f713238797a3b1945f97743766151a27b9945c"
    sha256 cellar: :any_skip_relocation, monterey:       "feb158b48cbbd3f0a451969192f713238797a3b1945f97743766151a27b9945c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fab4c651a2b92463a643615ea80996674ebaa3bb7f313728e3878848eb75556"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
    man1.install "docsxq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin"xq", "<root><root>")
    assert_match("<root>", run_output)
  end
end