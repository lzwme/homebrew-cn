class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.0.0.tar.gz"
  sha256 "d18cfc3b11c9a139cbb8f5e210f070dbb2ed40a4cda6f28542ab8513c6928fe5"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ca78c49ad2d5cb6a764f2151e44b9d00fc700de02f23bb6b34410d3a53f3d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ea10b1c1ee1c7d820946dd579f8def2609c4afa0b7be676ff6bad4ab7067be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8f24304e8cbde4dc9b9c75a86bc017a21c5f68c1c2587ef16bd6ceaccc2535"
    sha256 cellar: :any_skip_relocation, sonoma:        "6621a12af465635c906d2a336e0da3702cbfff678229a56dca78d53539708aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8d4d0efa15ae7049876e8d726b8616402b307cd22f142de77b6f662acc333c"
    sha256 cellar: :any,                 x86_64_linux:  "092b8a7725052c04d30a3597b5d3077c6bc1d3b31092444d885255c38d189bdc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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