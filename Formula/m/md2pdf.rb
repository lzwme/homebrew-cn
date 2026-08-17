class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/md2pdf"
  url "https://ghfast.top/https://github.com/solworktech/md2pdf/archive/refs/tags/v2.2.20.tar.gz"
  sha256 "7f33cd1ca648b081640ecbf654704fcbab9be78823dbb7e4aad3691bb0470648"
  license "MIT"
  head "https://github.com/solworktech/md2pdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f79d85bfe8c3485d7bef386f0b509d786fdb3ebc0d402f9f7caf89e06b6ca03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f79d85bfe8c3485d7bef386f0b509d786fdb3ebc0d402f9f7caf89e06b6ca03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f79d85bfe8c3485d7bef386f0b509d786fdb3ebc0d402f9f7caf89e06b6ca03"
    sha256 cellar: :any_skip_relocation, sonoma:        "db98558a30d42803b3ebc2e15c52a4821fb5d4d25af3403f741e756e55fdc638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7690604638d92638f7206bc612dae29099370905a36909ae2c718ddf36862de7"
    sha256 cellar: :any,                 x86_64_linux:  "a3c53d5a5416244731338cad04dcd464ca004342e94da7106ce839e2b7280781"
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