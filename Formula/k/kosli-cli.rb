class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.2.tar.gz"
  sha256 "433d2ce9132d6467ce5b8dc06f93d9efffc769df45d269938f72a5d1e6a0f6e2"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95db8f308cd66250bbc0f51519c1f337221c4f1cc55c63e6a0886b4a6ae2322e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596514c9ca58380342ca5bf0e64e519bbcbe17578cd8a1168f73c020c98267ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4b4587abca5a14c0ad7bf3d62672f96c796f0d1355c65d9464ee06c12e5881"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bbb21a99c78b67fa96f44c96ea869402bcf48b32e746fa56a6033b6e1060616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6328c108cdf9a93def161893f0f9745187235a95e9616e642a5c40c20ac4989"
    sha256 cellar: :any,                 x86_64_linux:  "090e0878cee454b88a4631610aa2c6cbba0badcecb2343ad82f3aba10b1fe7df"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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