class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "c49e9dd09ec65f6820ac4e826aeb8b05ba74b577f011ff71b69dbb0337440397"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "707cf32272ab3579ed77cc9956ac24ef683d67e4674e855fe7285626ad3da576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2d180df025a9e6199b6c7d9fa1eeaadaf59eda0b8a20e7303bcaea71081bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c095965f4ae600e96b58087bec76917eee9bb791ade360784666ce33a0d5654"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9060ded7ed3a5953120bf75b8cd1e5c2397f10100dcb8ba30c56afe74fd3b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c52b3819908777c1df5d36daf40f9e320390113796fde39a1d2e6f2c27b46c2"
    sha256 cellar: :any,                 x86_64_linux:  "33b943543cc2c3d335b07e9b4bdd76f4c412fdd45c532d61a252529bbc5f7a5a"
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