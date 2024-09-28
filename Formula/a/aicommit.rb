class Aicommit < Formula
  desc "AI-powered commit message generator"
  homepage "https:github.comcoderaicommit"
  url "https:github.comcoderaicommitarchiverefstagsv0.6.3.tar.gz"
  sha256 "f42fac51fbe334f4d4057622b152eff168f4aa28d6da484af1cea966abd836a1"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08f4539b07833129078e0f2ed41c8d219e6267c81162e29fdc8d666173f8e1b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f4539b07833129078e0f2ed41c8d219e6267c81162e29fdc8d666173f8e1b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08f4539b07833129078e0f2ed41c8d219e6267c81162e29fdc8d666173f8e1b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "df069029e846d7af4a9350bf8e5e47d3a2269450de5a34a60f594e2d6c2ce0a1"
    sha256 cellar: :any_skip_relocation, ventura:       "df069029e846d7af4a9350bf8e5e47d3a2269450de5a34a60f594e2d6c2ce0a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed14aa942b8c6bdf1ca078b49bc40e1a84c653cc8b5165484678b9d74e3f8ce"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), ".cmdaicommit"
  end

  test do
    assert_match "aicommit v#{version}", shell_output("#{bin}aicommit version")

    system "git", "init", "--bare", "."
    assert_match "err: $OPENAI_API_KEY is not set", shell_output("#{bin}aicommit 2>&1", 1)
  end
end