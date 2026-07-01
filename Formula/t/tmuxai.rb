class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "40e2027a162003f10b6f428449b33a09855c8181b989283f59b8645b7808f385"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb9253da71b8ae6fdb9aba4e43248d24b8a979a68ef82c3021ed35b05e002948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9253da71b8ae6fdb9aba4e43248d24b8a979a68ef82c3021ed35b05e002948"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9253da71b8ae6fdb9aba4e43248d24b8a979a68ef82c3021ed35b05e002948"
    sha256 cellar: :any_skip_relocation, sonoma:        "f22fb71c776cb6c6d9cc8e070e61794a1084bec4193b6a87a816524febc1be32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "293a33de8e58f38a695edb8271f38f97e945cd9373d89dbdbe0ff9a0ec11f91b"
    sha256 cellar: :any,                 x86_64_linux:  "38b5316876f61e36ab5aaa2c924724883ab2703e495389461f6bd4dada8a0650"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end