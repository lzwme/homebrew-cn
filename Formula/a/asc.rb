class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.7.0.tar.gz"
  sha256 "a5434d46a19b2276bae8f0d837f38ac83d94be2e03f8bca84f25dc5f9ff20221"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fdb4a26dc0a6f309988db09169b861a1c133f02bdd5d8284ab1287dcfad3a1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621b0963c931192ce645ddcdf29147a65d1faee3d215d06a8b7572fa8ee6f443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1178f531341aacf3a20265d6d2be7f1db301ec39ee6d505e3348d78009910722"
    sha256 cellar: :any_skip_relocation, sonoma:        "2370ef14996d550daea824b4580740222cbf374a7126d1da606a3169518ea205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e866788cd60648910fefb7e7d3b8ab7151d57e75e08daca578a1790d6767edd8"
    sha256 cellar: :any,                 x86_64_linux:  "da53aa639afdc444f7227bff8e15f14a28978f00c40362efe63797eeec4931ac"
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