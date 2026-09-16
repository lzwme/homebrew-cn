class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.3.4.tar.gz"
  sha256 "1e58b2741cb82f2f8056de3838d0ca6f4cce9ad4a0469d4177324404673ba7bf"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f5088fc693ba79c18b2e5a3f53e221d3d4cfe1b863c1f60c614d71a15b40696"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ae24bc1dd836a78e6ce73744d43c49aa970e108697f15ad53701f77d1f3d8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fedc2e647eb7f4cc13106a1eda9688f03dd839619d1f99e7f88197122455002b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f6197a67096c819e76a09524bf880c5b14fac81b437785603c83a61d2eb2bd3"
    sha256 cellar: :any,                 x86_64_linux:      "08c67cf17061533550ed6126d0a90758cb1a2998cc11a5243c49f7eb830f2ee0"
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