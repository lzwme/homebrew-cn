class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.11.tar.gz"
  sha256 "b596a890dade406d73dcff229f9b8b62b87fdfc435abeddc9f7e6e99636e9f1d"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8e605d01920cadec333490f253d7dc6c6afbd322b31057bf7fba1b613a27f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b8e605d01920cadec333490f253d7dc6c6afbd322b31057bf7fba1b613a27f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b8e605d01920cadec333490f253d7dc6c6afbd322b31057bf7fba1b613a27f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb771c0ce50bd18092c48b594823e33b4d23ab2f5b208acd2d6e9501f2138db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdd787d1c4ac497df8968a3a54ec7dee559305892d23484e30ac643f9e4708f4"
    sha256 cellar: :any,                 x86_64_linux:  "c7da1d627bc4e00ea739b51b290a3f6e784aac86bc22713816773912d3417e08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end