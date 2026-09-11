class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.2.0.tar.gz"
  sha256 "da091c4892e436fd14d12b9593d4178efaec26cbab6dba6536f0db29d4cba7d1"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897d384d8f3579770c51559529ceffd268dfaa0deb138cfeffb4b7ca65b9fd24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "246c4f1c6d405a394e639dfb7091bc6144ade60e4fbcee6446d4128773589748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d441b49f03926ac0e4f02d7a412a8983a3a69b02b018349ac172c7da852039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbd774de59e4587ab1dd6ba6584bca42ba0c73e279269503837ab80c1dd6b14"
    sha256 cellar: :any,                 x86_64_linux:  "f3f7e5e57c660524be80365b9e84b55109fdaee82138413436cb57e1f742888f"
  end

  depends_on "go" => :build

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