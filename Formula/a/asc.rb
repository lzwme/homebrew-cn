class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.9.2.tar.gz"
  sha256 "d96f1ef5672fb675188128c3186cb40b353b4fd6011cc7a57c9260596e88b94f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2f412c69998d43b10d8bd272fe8391840268736b708884885c6ee447a161d1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b91754d85ceee5259ab18b3724f05113f7e20798784e664306b1f9d445da396b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57e269b51f53570becd0a81296d5bb063872ad951000db4abb5d1d5898f05d16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "68adde319f75459d1edae9040bc35ab911ea0a8ddf4f42472b054d135feafa27"
    sha256 cellar: :any,                 x86_64_linux:      "8ba3751d45a69d6c7b3958f3a56715516b2c9b78d8f05d80d4ca84c42c3fc9c9"
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