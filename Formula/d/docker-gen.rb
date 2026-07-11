class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://ghfast.top/https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.17.1.tar.gz"
  sha256 "3ffde47b1da536b8c2c4143449b0b01b3ba7bcc7da735bbc2dcb12385cbcc068"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef03e89b44bf3ca8d705f07a80b8973095dea58bb5d4e0e58f987eed0798975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef03e89b44bf3ca8d705f07a80b8973095dea58bb5d4e0e58f987eed0798975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef03e89b44bf3ca8d705f07a80b8973095dea58bb5d4e0e58f987eed0798975"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fded5f5a30e652f9861c1fea3ace9ab88d593fff83485ddc60b6157d457985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cd1b4c0e72bd7ed1bfcbe56dbaf2ec5edec09b77c9a31331977368a6186e7c3"
    sha256 cellar: :any,                 x86_64_linux:  "190fde1d5caab6c0e7ade8a9b07afd7d8fe1a3be9eb653efa9f2f77ba4d5f1a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end