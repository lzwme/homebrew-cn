class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "ad85090a6ad507b5109d92fca5217df2fefa3a1879b67cd5e2327fb153245473"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eae42ef3630b3bcabd03e135a3c750154ee5644eb205fa6256c5912368050e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f9bda0d9ec50cab0adcbfb755eca2af7203e7cd64e083ccf8b688aa296b7768"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207b30da58cbd7e52552ab9ccec85fdc2f58499f810ed27b48f5ded5a93be0dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "466660a486d1177cd770c7f571aa47d6b7f46f49cb3cde83dea777aae548aaba"
    sha256 cellar: :any_skip_relocation, ventura:        "1aaf3ec1535f454082d58e1b81c5924f26b51d4fb7ed93c4fa64304ab66975e3"
    sha256 cellar: :any_skip_relocation, monterey:       "412f54f0a1319cb33c3e6531af07021caf731d0c99bef41512337668188fb83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99591405646c1e7053e6ab7ae9b1dcdf112f9e9f46d454588b20879e9a83161"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end