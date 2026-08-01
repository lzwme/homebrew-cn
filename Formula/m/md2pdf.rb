class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/md2pdf"
  url "https://ghfast.top/https://github.com/solworktech/md2pdf/archive/refs/tags/v2.2.19.tar.gz"
  sha256 "5e1c8edfd48a88679880817b243f0d2068a695143dbf31bdbb85dfbf2e6febee"
  license "MIT"
  head "https://github.com/solworktech/md2pdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2da752b31bd705f20e3bac7119450945cca69888cdb7d69a381474680fa832a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da752b31bd705f20e3bac7119450945cca69888cdb7d69a381474680fa832a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da752b31bd705f20e3bac7119450945cca69888cdb7d69a381474680fa832a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "41decd85836a3599972ddb903fbbe2ce684aa27193c924e6abbf3fcdbd2d4265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ef0f14a22be7663a5a3db503f5270747a754493d0c72c0bb260ab3c3b897ea7"
    sha256 cellar: :any,                 x86_64_linux:  "9407646fb7454ba0d92ed60be10aafcc38dc52619c3ca2239f7ba6beb7bd2dae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/md2pdf"
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin/"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end