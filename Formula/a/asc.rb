class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.8.0.tar.gz"
  sha256 "093b1550e4e740837487a0045eb4adc1dc0a964813065f84662c96111f3dd44a"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16ff6e7d6f5ff1c40757b806e0524e071b1e583a1783efab2b18e7164e6d7e48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76f39b20f2692ea423a69481747e7aca521ea00c81f64948497aa211309e32a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c93d1a1f6b67f40f030c214dca325bd9388a3aaf43c747230b4c4ba9fcf0bfdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29e31227684c29dba02ac7c330b4fe2a0c35fd2b8648ac6d9e51ded1259b04e9"
    sha256 cellar: :any,                 x86_64_linux:      "fc02fe4f5d1103ed7c66094e756457f2fbc869f941521924f3cb7bfa7a1664a3"
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