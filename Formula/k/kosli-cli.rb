class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.46.tar.gz"
  sha256 "b85b718be315a0b2325e900eeeb98eb87a73ab6a3953a39247dc2338f3895758"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c1d4ba46dc6693ae15459e4385eb8e29c1ababd2b15b5ceef5fca42ca9c83a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9081fb268e6a0c37185f9834a8fa3ab1e729ae52bfcb09161d0515854851f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff18131153cc4942026b84517e25a3a4eb516040afcb98d8d2fc94bf5a79da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd2577e03b5f584d77cc06230e83cfa14bbfb4a655c74d3d786a72f13799f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a5c3c04a504e5e330b62889f34a5a4c483f4141d92c60132f566d6b979e935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29710a06800f342ea8f427557a709228dc397190a39d3f7511676e946addede0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end