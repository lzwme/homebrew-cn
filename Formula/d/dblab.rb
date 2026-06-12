class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "47319251e132bd400d2c1543fdd7d0129c935751ae86c5a8d9eca903a3d928d7"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86aad50386d123d554280a59895a5c215976737d11c61a82cb6a75d87ba27f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecc15c769096a0cc45abf09c07f121dc385619ff5c97ce33c79ab6b19d03bfe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e0f45c736e2a348dbe76ba03d9d4953e14a16b06b6dc0c651689187c6a946e"
    sha256 cellar: :any_skip_relocation, sonoma:        "486c7e9da4cad73a971cc898eb439e023f0e2fb9ca6c6787750c91c019d0d02c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe247c21b3557950ada7f3497841bda6053abbc573bb91a0ddf36a7fa445a212"
    sha256 cellar: :any,                 x86_64_linux:  "f90decdfd67b09480cbe2bc5c3d880dbd9d6c5d62f32b7e40de87d8b942541b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end