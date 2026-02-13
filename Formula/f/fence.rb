class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "2f0b24ce5cd9092833734c1903aea8b835eb48287815287dd2a6e37ecd3995f1"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24bad36f86d2bd55b62dec0f520e62ac3665d517b2aa3667cf689191fc4a4a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24bad36f86d2bd55b62dec0f520e62ac3665d517b2aa3667cf689191fc4a4a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24bad36f86d2bd55b62dec0f520e62ac3665d517b2aa3667cf689191fc4a4a93"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f71e30bedd8be01b84b149c37c39e091591d572021273edf5029a3afa12c4cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60675e1f740ea457fb9a0b9f11e9a36068ab26c589af58e7c9a29aafa6d27f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae89aeae892282eb972ad4154f99acf3282eb4ce6ca8f031899f2992a4912a9e"
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