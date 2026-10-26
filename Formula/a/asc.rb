class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.17.0.tar.gz"
  sha256 "721d7808a1b7d7562b4c297b5a166f68d9ac19b9edc8ecf30a8da3c69dec92f9"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70d1fa4e09e462a5753fe1bf2193f44eeabaf41c4bc0348d199d79724f0cd2c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbcef1c39d904bf24b0b76fd6e22558178473beae6de37afb1cd40db6430337a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb43ae6e5b1eb4e923c7dfbc8c810b45ab6db011ad583b3f36845985ed679e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eecea2695a56cacba34fa31fc9a8b7f6d40429ec7b264296f986917d16871f0b"
    sha256 cellar: :any,                 x86_64_linux:      "7de49db07552b3307a857f360362873af8b6728de5c200b51e11e234812f40b7"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

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