class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://ghfast.top/https://github.com/descope/descopecli/archive/refs/tags/v0.8.14.tar.gz"
  sha256 "12bdf378ca812ae85ac3b482e7067ede9c576e27aed672fd1027a8cc130e132b"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ffb03c5de523a9d9ca622ff0db3882ed43750bae96ed2806526fe2a506efb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ffb03c5de523a9d9ca622ff0db3882ed43750bae96ed2806526fe2a506efb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ffb03c5de523a9d9ca622ff0db3882ed43750bae96ed2806526fe2a506efb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1983fea3098812cc34c649bda7cf330a407738614528c6bf73224e8612790a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9095d2d63e1d857f1dc58e852a27403d1282204bc5304d3bba299c5989bde38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5a2d37ee7a0c569eba84b9ebbf85163bf4ffb3749176cd0ee02e4e7c61bf9e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", shell_parameter_format: :cobra)
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end