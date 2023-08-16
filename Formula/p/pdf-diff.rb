class PdfDiff < Formula
  desc "Tool for visualizing differences between two pdf files"
  homepage "https://github.com/serhack/pdf-diff"
  url "https://ghproxy.com/https://github.com/serhack/pdf-diff/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "13053afc3bbe14b84639d5a6a6416863e8c6d93e4f3c2c8ba7c38d4c427ae707"
  license "MIT"
  head "https://github.com/serhack/pdf-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66929021a8898ca16128f0ed3b1fb9ffbc4ac8b5778bdb48259207c91daa64fa"
  end

  depends_on "go" => :build
  depends_on "poppler"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pdf = test_fixtures("test.pdf")

    expected = <<~EOS
      Color chosen: 255.000000 32.000000 16.000000 \

      Image generation for: #{test_fixtures("test.pdf")}
      []
      Image generation for: #{test_fixtures("test.pdf")}
      The pages number 1 are the same.
    EOS
    assert_equal expected,
      shell_output("#{bin}/pdf-diff #{pdf} #{pdf}")
  end
end