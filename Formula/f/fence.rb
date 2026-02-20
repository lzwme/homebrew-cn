class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "d5b2550bc8b8c8879c7f62e9713c517f6a6cf61b9be686207fc6b1f2ffb099bd"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c17423c618f5fc6c209f0e0546c2dd3967b2e4cf0f13da0152aa991356001710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c17423c618f5fc6c209f0e0546c2dd3967b2e4cf0f13da0152aa991356001710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c17423c618f5fc6c209f0e0546c2dd3967b2e4cf0f13da0152aa991356001710"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d072f5c05400de0592c0cdccc7a4fedfe3e442a723e86a9231f41a6a9bc4804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f89c1eb648359bfa4f6a8b9516a9c2cdf02fcf44f8b449bfe0eb945663195d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda5a9bc97612fcfa5a2fe3274e17e9741dfd44b17e2e6f9a00fef2cbb8762db"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end