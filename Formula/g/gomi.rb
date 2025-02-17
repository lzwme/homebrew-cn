class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.4.2.tar.gz"
  sha256 "3409175045abb07ec0a0104eb76c436695669202ce446903de467b69b3ec8c66"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b8038b9f6e0392e4df6048a1bdff7f2e4ac8bef0631fc736f63afe48a9a052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b8038b9f6e0392e4df6048a1bdff7f2e4ac8bef0631fc736f63afe48a9a052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0b8038b9f6e0392e4df6048a1bdff7f2e4ac8bef0631fc736f63afe48a9a052"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db88a059afc9647ab752295786eecab5d6be96ff9693b9de33cacba399504dd"
    sha256 cellar: :any_skip_relocation, ventura:       "5db88a059afc9647ab752295786eecab5d6be96ff9693b9de33cacba399504dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87a080ab64dd145706562b6778133b2c3ed37c6f3dbefe317c9dcac079eec17"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end