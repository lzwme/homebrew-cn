class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.5.1.tar.gz"
  sha256 "c9dd100a012438ef846228433536f63dd1898eb4a301bc9f26c5d5f8dbfcf103"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9071075a830a349b684795bd4034b5b21d75cef6600a282dab578546dc24713f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f160c619a7cec0d227f8c3a6fbb5c2a171721950169b0e659b6e0ea3778e5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64190f274f140d96d0fb3d269f12f26838c5d3aeba8dbbbc3af73d8804940d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "168315b92a674c9b547ce0fa04161c92d7d7c62505498cd47f075c8ad66b0da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4a5d9c4469e17d1766f8f7a9df04f55ee8942cfcacf2baafea57fe1981e2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d3cb57fc5a3fe18e4ac85fad406220d7067786116d9f1fd9ca0f0ee027b0bbc"
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