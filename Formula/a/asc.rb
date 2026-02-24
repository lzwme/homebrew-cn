class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.33.0.tar.gz"
  sha256 "6512b8471f163d87205cf75ae75440fc83efca683c0798ead32ffc744fd4e22a"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a2250d003cec5f4943c59b0eb6e01cce8c20ea829e1d0d112af6612ac7edbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75598e8eb920e13dac374a67358a30fd26db60ce73a2386b335e756c0c709355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9ea14dcc4edaf9bb7d1a14c5df9bcccf9a9aad4408d68c0e31c74560d059ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d95eea06fe0b66be6ee18a06594125eac55e14bd15b6d34bba05d623ada71198"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c35a967cf0fe1580a6290e68942bf220dfd0e8e656a19ae804b0c8ae81c68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6c83b49b140e619b7555c935737c104ee9d5c3cbf87770727d5d7d43024c6a"
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