class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://ghfast.top/https://github.com/mindersec/minder/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c773a4875cbd8c79bf42023461b3622affbfe8543ecf67e88eadecb79b19f019"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042dba0bda3bf1d38e61706b567086b93b03526a328caa08dc11cdee911a6b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "042dba0bda3bf1d38e61706b567086b93b03526a328caa08dc11cdee911a6b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042dba0bda3bf1d38e61706b567086b93b03526a328caa08dc11cdee911a6b5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3264bb3fe2baab89375f9cb04c4ed4fc5b20f4279681b29c8f72cd93171ed63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4366bf17fbfb873f112e06202fc1d64ee22bf5782d3794c3f6091f75f5568bf"
    sha256 cellar: :any,                 x86_64_linux:  "4a3a9e542c0a0c77c7da82b0b8d7ab15020f2bb8566703d6e3c08e974a7012b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end