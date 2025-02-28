class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https:html-to-markdown.com"
  url "https:github.comJohannesKaufmannhtml-to-markdownarchiverefstagsv2.3.0.tar.gz"
  sha256 "39b0078fc5deff3990a3fbaab43083ca083fc562ea73302a1d7583495c4699e2"
  license "MIT"
  head "https:github.comJohannesKaufmannhtml-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb21d1313f47f5e2110e1145d7e0649b568f57226d1fd2605d3fd7b962e4c00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb21d1313f47f5e2110e1145d7e0649b568f57226d1fd2605d3fd7b962e4c00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb21d1313f47f5e2110e1145d7e0649b568f57226d1fd2605d3fd7b962e4c00f"
    sha256 cellar: :any_skip_relocation, sonoma:        "805eb6b305354ca461fad370a9ac75d61e48cfb89392561be5c105e1eda4a4dc"
    sha256 cellar: :any_skip_relocation, ventura:       "805eb6b305354ca461fad370a9ac75d61e48cfb89392561be5c105e1eda4a4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29074c57de20e57f8b2bd3335542ed1931c8517a09aa0e4e97c2f64f141531a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clihtml2markdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}html2markdown --version")

    assert_match "**important**", shell_output("echo '<strong>important<strong>' | #{bin}html2markdown")
  end
end