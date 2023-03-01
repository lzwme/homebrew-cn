class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "828661a68d85169a80353927c86546a66a27b9fa8eca376ec6b90b86cd47252f"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c6f371d49b70bb01c80f16c875069ec7bdbf61e19a61813cdeec84f7ef7e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a965124ea3c0e59167f08763cdc880bed9a9f5c74a9ab8c881e5b6bca952979d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e703ed8c76c0f340d0936b120711f7fde980251cc59fffc1ed4abc532af1c74f"
    sha256 cellar: :any_skip_relocation, ventura:        "ec257bc791105c2c4da0124674e6089d5bd232a886845c1f76c4dfdf6dbee37e"
    sha256 cellar: :any_skip_relocation, monterey:       "c748ddf03f2f1247af2031d759390e2ecd9f2d009ac03c9a9e38e3e169be8285"
    sha256 cellar: :any_skip_relocation, big_sur:        "30eb49ed23f771208ed464429b0a27a4c13c8a88382d0a1a30a9e6c19c84b718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d8dda4098e157c8f7f7e9e487c65bd79addf219990177328c0e3eae44e43b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end