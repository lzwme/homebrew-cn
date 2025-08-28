class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://ghfast.top/https://github.com/noborus/ov/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "e143cb8c817f68ac3737bdce0a7b098cbf0243a9d8274600f646686d867c70e5"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571e44a28916a6a1167be4ecf39bd1d2fb66a35907b2004e4533c438d1f7b33c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "571e44a28916a6a1167be4ecf39bd1d2fb66a35907b2004e4533c438d1f7b33c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "571e44a28916a6a1167be4ecf39bd1d2fb66a35907b2004e4533c438d1f7b33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "347c7da7ac885ac472d8571bbf47c26cd4b5b38dd8b5f69dc9cdaacca1a65fe9"
    sha256 cellar: :any_skip_relocation, ventura:       "347c7da7ac885ac472d8571bbf47c26cd4b5b38dd8b5f69dc9cdaacca1a65fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480008502c8a40ed47cf1c3c81777dd3f26174c889fd8a683f3310500c56a936"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end