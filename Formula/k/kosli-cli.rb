class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.19.tar.gz"
  sha256 "d89cd95deb02586d5782a08a083b0fce3523c6c103c2284434e7130ed01675c8"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b41bf19295532e226dfcddb305f0859587f41f217a913fb517dbb363ec4081c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "675a75455f8e833355ec4cc595073e7d58cfa167b775ec2182a2acdccefeb95b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a525a184f391533376c17a195d17f44853846e546f6c4ac13e847b836c3f268"
    sha256 cellar: :any_skip_relocation, sonoma:        "49c99de87ab79fa855571e0306cd5aa31c815487535f33ebe4c3a7f9039ac04a"
    sha256 cellar: :any_skip_relocation, ventura:       "5a4dc62a00f2b50b670dd633b300e73c929692f878544d4330c23bbfbd8ac580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3479b25b9256b7eaca1d8ffae651852075fdf291d90df20c0a2abe521ae6bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92e15690482cf3b9304853338ed43e4ba5731586dd66b3184b2f19b5662c4f5"
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