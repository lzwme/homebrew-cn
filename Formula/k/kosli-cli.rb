class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.26.tar.gz"
  sha256 "929d45b0046127fea8faa588962d52ee3e705990107b19962bb154ad3dd3de02"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e9d6d0b72bc9ca13a5c63ca64643eee71c849f371aa62fde4740ef1d4b5ceaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a747088534ce6aedbfeff367afcab04946f32d7fcdae045ee1ba9abc9a75ad90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85f757632ed815c26f29f7783fb28217402299e4d72bd603034bb91c6d2fc06"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d5d53bb11c49cce35b1fb836c6eefa12d63ce7bc802ef50ef252ca0efe16a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42beb381e398b3b08c6a56a059aa6882568f6b61812b92ce7c6618f8ab690b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52c38e0255868010080eff4348d64d92b54c2f8a897f65bb9df788821dd15f0"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end