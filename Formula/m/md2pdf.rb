class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https:github.comsolworktechmdtopdf"
  url "https:github.comsolworktechmdtopdfarchiverefstagsv2.2.17.tar.gz"
  sha256 "0beb5f136a6d41b3ddfc8fed233ea96cb4d1717d67d5d7209e0982ec8f161ef2"
  license "MIT"
  head "https:github.comsolworktechmdtopdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff52784e2e724ac33d5ffa5b850a2afc618eda444b17dd08e488ea0df2cd515d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff52784e2e724ac33d5ffa5b850a2afc618eda444b17dd08e488ea0df2cd515d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff52784e2e724ac33d5ffa5b850a2afc618eda444b17dd08e488ea0df2cd515d"
    sha256 cellar: :any_skip_relocation, sonoma:        "274fe07a1fa7b5d769609d585614dc9b74d45ebe3b721738c97751c06475861f"
    sha256 cellar: :any_skip_relocation, ventura:       "274fe07a1fa7b5d769609d585614dc9b74d45ebe3b721738c97751c06475861f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45567c571274052dc83e71fc228686f9493ceaf28892593b77105dca3d0b932"
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