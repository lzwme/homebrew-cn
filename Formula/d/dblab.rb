class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "7e60027b9cfebdd1e0b5714df102c41b89867abc9b19d235759ac6d9e1abebab"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6803adc8128a69b48b6849b2a3c8a1de74978752e1871e194627bffa89835ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd55f899fb44382ed280191680c4c217afab54d71a744d4a022220449d7b4bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0fb1f2ffbd235aa1656b7009aa868415d5d07c55dc92da88985460bb09a4be"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b0d5ed3601c4a4a920a9a7c21b498a97246d0ec42f293b4c74e6e6be4e51757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6504499802f4558af9b1f67c0fc0be8e2c7a30c74506c28edc83afbcd0a715e1"
    sha256 cellar: :any,                 x86_64_linux:  "b868806e77251645269155af785243a5a9376d2dc15ff3551b7204295461efd5"
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