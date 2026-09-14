class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.3.0.tar.gz"
  sha256 "4c11b582f90992e4c420d08d57a0f2b04a2ad63e80a214504e400f5603445a21"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aff3869400c4f18f36803be172f91bf9273e682751d91076b4d704f782c22f2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1b3cab37d6800eac4a3384bbbd024e8e26fc8b5d814a0b9c651dbb9a51805fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "903917449e01309369d503a30102aa46c7cfc3ccff74d4df6daf52431b6cab4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbff313c35ea323deed73da3a49315ccee2b74b991f7dae947d78e2aeb1794bd"
    sha256 cellar: :any,                 x86_64_linux:      "a08a12d6d1d3e97dc29670d6c126f3d7c9da4660c8cc1a79c743131fddb47f53"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end