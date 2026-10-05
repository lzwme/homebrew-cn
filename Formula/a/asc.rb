class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.10.0.tar.gz"
  sha256 "87a0c4a55c40ecae55ef67ddbc8bb2898118a62017d8794ea6b7f9120367dc0d"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43ada8737cd2b526f52e17cdee9c758fb0200fe38572a112d9289cba74e3abe3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed1b6277c0345c112f35def13fb02ab704296b1df24c113fa84985200bd33c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ead241704862a0ce283e85bd65dfd74bb110149f9344c5bb11632dd92de8be52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "746b31c5a27f19359a20eae0b87d104e68af02ff4bc9409d9d680e545e5f2dc9"
    sha256 cellar: :any,                 x86_64_linux:      "7a310724a6985f4033006cc0ee568c2e8f4a3b1266e6d1eeedc19a8f928a8ad5"
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