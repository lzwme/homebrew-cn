class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://ghfast.top/https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "1a5c013735002522b9a628557cafa2a4165f777b7148fb5acb1ab4d36aa9c979"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "253116c7bf812feec58a2b05be88f4517b4ed3f5e11bb43f798e1f5d4206ec7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06c3839f48fc514f79a2bab28f5f92ebf551186403750f3f69e860f9b710509d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "830127bb40f4588e29073e2a8a37e80ad56eb559b42805637b4a1823815dae39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d405e92b3c3ffe45f1cdd0de6aea1681ab3926c0e3efd7e55bc12405c51273c0"
    sha256 cellar: :any,                 x86_64_linux:      "d0d4a12ef320fc843e3d6b0dca0a4abcc0d1834ef2b215fd2b466dffdb83eb53"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end