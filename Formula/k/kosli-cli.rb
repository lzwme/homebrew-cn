class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.42.tar.gz"
  sha256 "0033b98734478da25783d458063abcabbff09baad437f26dd3a24c2f1182768a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a86e61510e775f784f16e7aaef50e2227ea1d015d49a86a1196ee67f970ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ebf0c906c8f6c65d58351defea57e34a6aac209cd97192c2ac9b85b275dd359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7c76a69584b7f0d422db44251ed7dcb3b577595ef3416a9031862cfb6d543c"
    sha256 cellar: :any_skip_relocation, sonoma:        "040353640aa00a300cf683a4aac2b35889f8f8d61127f4c7c0c7a2b077e130c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0232877bb37c2ca22e43720d2a5f2c0a536f9dcb356da35ce0059874946ec3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f550621d06915e13eebeeb3f1e705b4ea4bbed3af4049a1745ef704d48a183"
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