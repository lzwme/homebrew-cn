class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https:github.comsolworktechmdtopdf"
  url "https:github.comsolworktechmdtopdfarchiverefstagsv2.2.15.tar.gz"
  sha256 "a7efad310c97440e6320678cde7fc51ecd1d552e2da417faefc191f9e5037805"
  license "MIT"
  head "https:github.comsolworktechmdtopdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618ca3284115e532e2ce80889792492b1d22077124cedb2cc7085a7b2212b026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "618ca3284115e532e2ce80889792492b1d22077124cedb2cc7085a7b2212b026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "618ca3284115e532e2ce80889792492b1d22077124cedb2cc7085a7b2212b026"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ad997fa07601ffe927913ea0e9c05dbdccdddee707770086057a79ad5f7ec4"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ad997fa07601ffe927913ea0e9c05dbdccdddee707770086057a79ad5f7ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9e901ede7735cbee52dee13ccb89fd7f1cf4b8450b35574f533065273501f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdmd2pdf"
  end

  test do
    (testpath"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath"test.pdf"
  end
end