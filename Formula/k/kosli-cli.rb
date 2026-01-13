class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.37.tar.gz"
  sha256 "f76f72881fedd96049edf0a0dd7d6c602c89898de21fd3bb4a6a8338010cbcb1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49132309ff1e9cc368abafcd60937cf4f627b94311d984681c1f29a28c8bb02c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848cd1b2fd559d3c014bb0028bf211a28056d1c2f0bd63965a99d05f50d6dd7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81789f45b15e61f6a068bc241eade3f1a315a38bc6f685725217684912c8d404"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9f33a1c9c3d91f4dbdbdb6df11c3b77f033854de1db80879398513a741c0b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f10f48da6a13170e554d9c919932c76638f8bd7c12980c4ee26e5165622c9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88528938769346ea34f64f159f3842189bbed92494802bc7fce423834c0847db"
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