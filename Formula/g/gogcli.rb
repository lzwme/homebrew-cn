class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "8ec6c3ad838ad44b6dd52f40e2af180afbb57d21bf329577f7a4f776c6538054"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "938642491433d893efe061bda5de8da1fecc5a479c218fb79ad49a998ae9e472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b8ff33f97f2845fb01bce919b7579522cb35295d70b4ac3114df0b1132c0fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba3960421dc51afa918701e5721e0916e15340220784ae58456bd822836b5574"
    sha256 cellar: :any_skip_relocation, sonoma:        "afeb8f289cbaa3d27335b5099a3909c7748aba2c5d07a414fc17faa9b53cf407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f2bab6076ca2ea7a4e822d5a4ae9b9836fb1bd6f49da2b97a4571d1c51dbed"
    sha256 cellar: :any,                 x86_64_linux:  "03a2a7ca2112f4cda9a90997bad34b5dc9b5385f42d2f7f2be7fbabca96f3456"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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