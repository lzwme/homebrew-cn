class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.21.tar.gz"
  sha256 "a8a81316f08678c6199d50b475f4dc51081d8eec0db23b3c97e7c467d0e91d49"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae68cc919a3986f9f7edecd07b00fda1d27f89882f2bd66e352441e1bf8ead9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4a9e46ffda80ccffbd056073a96413d9e422657077049bb5a79ddffbbdb21b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b81c351eca98a2b58e82b7e89e76915e45f1d5a373ca0c9804be2a5770bed5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "334b69856203ac4101dccd89ac25635ec812f8785945f4a184fa8989f482339c"
    sha256 cellar: :any_skip_relocation, ventura:       "b98e74a965156a632bba7d8b4d09a1ab6203a98fc0af2943a2d2588aca1039fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd5d6f848828de7021d408b8e01aee06d61ce3b8d4cc66e84d21ca81b6530d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4210cf73f70f7749f3a26f4155650dfaa28af776044c4a4040d83cc69c1efc"
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