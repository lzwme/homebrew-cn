class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.17.tar.gz"
  sha256 "48dd755a175e2b5ed0f166b3fda6324837d88e96ff8fbf16bb373bc6781330ca"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e07dab1bc45e664b863ae314d4ea414881f241db1822e79bdb8448f5991b87e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62adb7186bc5a6d42f992da0512eb02bdb36bc73c64bb615944b80f3ae87380d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11b0fa3a8f3ff242d6a75a837941f654f39801a2aa5a97cdc5a20c46476327cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f595e9d6096785da7f724dbfcf9800f29eb5e6eeff3c5d2b234a834371bed5cb"
    sha256 cellar: :any_skip_relocation, ventura:       "0fb3dde5d5fbfca7062da28fad2376c0739ed0638f08498463f4a1e6d85ab6fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a51649bfae1f0ce1ffbd6d9e8cbdf218236425fad6d7f03df9479369b2d694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c136939d12c8c221066f23962bbef6e0de5321c6a9c52fc4d96fe444774013f"
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