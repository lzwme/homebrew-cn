class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "b19484b7c0a87a155e5469d617e596b17cce88f4cba4a91ef7eed3a93f48793c"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a8a123fc9f71c413073903f0e3a3afa4021718b88011a8246e055924de14a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a8a123fc9f71c413073903f0e3a3afa4021718b88011a8246e055924de14a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a8a123fc9f71c413073903f0e3a3afa4021718b88011a8246e055924de14a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5edbe55c2a574aad7616302e080a37b2ca7b7546413ec5985c03259409a2c2bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b7f9ccb8fd40ce31d2765a5f6cbb046b5dafc6686cf8edd02a235e082114771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38c7db1a384144a7faaedae7907368b0fb9b620b79ea6919fce940a6b935bdb"
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