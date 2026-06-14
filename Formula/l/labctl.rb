class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.85.tar.gz"
  sha256 "077debb7c5d4060a583728790a01c8eea659f35c691d8442aa428331aca0c08e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa9aadddfb98aef4fcbb326145deed917059e4d6e3be757f93ef5b483997d07e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa9aadddfb98aef4fcbb326145deed917059e4d6e3be757f93ef5b483997d07e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa9aadddfb98aef4fcbb326145deed917059e4d6e3be757f93ef5b483997d07e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b6afbd9a7812e824f0805053bad846477cd2e163354937388f5c59eab1fc9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f419adea4f1980699fdceb1cfc1c397ea7b5979ee6e02eb1df3b304a034edb2"
    sha256 cellar: :any,                 x86_64_linux:  "8b224f48fd0c0309905d148f6eb6442f9f26bda508339318ac8aebe6c6562b63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end