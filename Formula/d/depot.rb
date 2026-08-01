class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.77.tar.gz"
  sha256 "d95c2bd2fe9d9c8c3bcf84ddbd48288d9bf31b100eec70edd0205dc1c4258b58"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "781d8e8e0c14ac08bc1429712fc0ff5f5fda485b3122c42e42aa2c2515780f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "781d8e8e0c14ac08bc1429712fc0ff5f5fda485b3122c42e42aa2c2515780f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781d8e8e0c14ac08bc1429712fc0ff5f5fda485b3122c42e42aa2c2515780f23"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf6d930fa840c8eda223bf431c1526049f29fd8e81c1284053eeaeafb502180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f763465a24bd7e2accd54f664e3f93682ed8454d674143f63970b7e0631571"
    sha256 cellar: :any,                 x86_64_linux:  "2546c5518f999ef2ccabcdc311eac000d1c0d64d4550b949718e45dcf0032040"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end