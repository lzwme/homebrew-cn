class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "929783261c500c5c3eeecec47397e6bd276c816ace255e89e8885800cae7499c"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63e4c45e7d07fe4512df8f579c39a778d470bfcbf5e2f2132bbc8a37993fbc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84cba37415c2c65538288bdc9fe1b4bd8b3f13113923fe3faf87fc44b32a73c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3bae58b11ea586d36a0b937bbf71c0f48bc1285090a16b6237efd5752d25f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe46ddec79fb850ca5f15ff76f9d551e4c9c96dd00379695862f5fb8953a8b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e2b2acf42d72f4787fdc4494c33378a375c1cf6b6878c528d476f3af7f7eef"
    sha256 cellar: :any,                 x86_64_linux:  "8b3f83561dea7321f0286a333a51103786f5290631aa80c829c3e850b822f0c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end