class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "81e9bfcaf23750c6fd67e8abddad56559309d851d02637e0233bdf546af71bbe"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f22b9910eca0404f3d503d7997a28f96f0ae48d102a4064233eb9e532fc1aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f22b9910eca0404f3d503d7997a28f96f0ae48d102a4064233eb9e532fc1aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f22b9910eca0404f3d503d7997a28f96f0ae48d102a4064233eb9e532fc1aa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1df40b384603a114294ec10dcda35f5cbf8a533689ce567a34afb80c1ff3bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d72160a2b2e810559337efeb9b7dee2182ec76e0c0b197d9932dde37732f758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46efde5a840f1b063b55bfea07b8248cb0d4e241fbfaf368838ea67b18bda6d6"
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