class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "a949d3d11eef02a030b82ad07d14ed62f02ee1717be2ef6317e729c90942c867"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172ed155d3e66ea13e3137bb879613e1f6202b28984a5114ce2caca57bcac23a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172ed155d3e66ea13e3137bb879613e1f6202b28984a5114ce2caca57bcac23a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172ed155d3e66ea13e3137bb879613e1f6202b28984a5114ce2caca57bcac23a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6786686d2c8fe9a121af64b558924e53887ef0d48e430641e366ec2df69cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5723683f68812753ac9dac05162e99d22fbd231e4550aced2a0909340b323e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce75ca114353836246e60c086a095818e5e05402fcac8bf905825f7886c76f68"
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