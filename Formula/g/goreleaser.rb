class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.5",
      revision: "4529e9301072ada49ea368d0e6a4ec2e9cfef897"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa9cb0c707e6f577b41214536b0a5c71c90d726bb27763663e7e3d0310d2f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afa9cb0c707e6f577b41214536b0a5c71c90d726bb27763663e7e3d0310d2f73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afa9cb0c707e6f577b41214536b0a5c71c90d726bb27763663e7e3d0310d2f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "3586f45563aa218c9496a76c381ed2007f4d9d5d4d858f4d917ce631ed5735e4"
    sha256 cellar: :any_skip_relocation, ventura:       "3586f45563aa218c9496a76c381ed2007f4d9d5d4d858f4d917ce631ed5735e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8199159362c898bf174b39a9f7e0296dcc96cfb9cee3d9b9fd79f2e4200f1251"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end