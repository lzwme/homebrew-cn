class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "e8c6ab4ae0d63aee5421f68d9b2abfcb00808316bf929f373db84182f4133c0b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ba46fd762f3975d5f6a5955690afbd2701da6095351d8b7ccc4e1a19e76ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1b6cf5d24ace741d74cbae1444f529f347490efd0243074f19269edaeeb7ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ead555e16e1f6b28131b8712868699793e2f0d1026cee2f88b2fc7bb8429dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce583d37fbc4c1b0c47e2d7bae0f5a60a2a7be64a3828bace509caf4d070f20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b30d4e4e65feced5a325ee2ec957d06f484d342aea4ff376f99f59a23d6cc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f80c5e6708a87aa3aa4165d123ade4f38b8e17f936c475df5e58a106c10894"
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