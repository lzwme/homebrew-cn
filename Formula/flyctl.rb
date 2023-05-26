class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.17",
      revision: "78070840ec8911b34bb9bb7b66df9a92642a2304"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c5bddd6d5ea803e945d89beb96f4f78274817db47dabb8e016c4d7b62379d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69c5bddd6d5ea803e945d89beb96f4f78274817db47dabb8e016c4d7b62379d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c5bddd6d5ea803e945d89beb96f4f78274817db47dabb8e016c4d7b62379d2"
    sha256 cellar: :any_skip_relocation, ventura:        "5c653d5dbd1fefbcca0ee5c0b24626f5b653b2837d947f9fdb7cc239576db138"
    sha256 cellar: :any_skip_relocation, monterey:       "5c653d5dbd1fefbcca0ee5c0b24626f5b653b2837d947f9fdb7cc239576db138"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c653d5dbd1fefbcca0ee5c0b24626f5b653b2837d947f9fdb7cc239576db138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f001d81cb8db6e457e37f4837f256b93b48f981cbe9671e2c088086dc16b8e4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end