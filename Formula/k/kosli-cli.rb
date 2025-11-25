class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.33.tar.gz"
  sha256 "0f7a5566b587ff9d334a3120269a1b8d0b5897868f5c8696f01309e2ef2687eb"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dbd093eaf9892a87ea66b0295e5abd12e8036879afc3da60e92adbe27916791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94b82b4226d6cb79abc95d84cc00d2e46bbf8af6cfc9c37002a173cec293c754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97d6b3bb2d22f08cb23f50704dc051b1e72cfde2db958b2bb617ab021c31b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "434f6607f7b2eee424dbcbafa1ff88fc0402ca6c0e9bfdde2f22f3d0ac05294d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b9a538f10d28abdfb4bcc0b0f7e48a7147777e9bd782190a1755cb885d5ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a69791cd38cc7741d32a85c3aa381960429af54a45857e9c038a0c60d85890d"
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