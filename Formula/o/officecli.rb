class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.129.tar.gz"
  sha256 "256cceb57a59b4665957a075f5de37e0c40504dd2ffe77143b0c6e0b03cdc14f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8961f5cd74c97910af5306ddf025c8c8de38f9caf258a67c5662850e66d4e1da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3551903c6b44ddb6c84cdc323c224cc90d511556000640efbace4cd3d4bc519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6dc840a9e3b327540f630933d4fe9088b79807abd5fa32165cad6c86e735d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "666fb59366489c8f9633221a8a506b69a7a8c5807f260c314d72611d3b2e0941"
    sha256 cellar: :any,                 arm64_linux:   "4977d60896802db6c1e085f1200e5a0ce4331b1b912e8f81cbc6e9454554d649"
    sha256 cellar: :any,                 x86_64_linux:  "7968a0458551132733b7093c3ed1535bd5697fef4a5247360aa11895b267e8cd"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishTrimmed=false
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/officecli/officecli.csproj", *args
    bin.install_symlink libexec/"officecli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/officecli --version")
    system bin/"officecli", "create", "test.docx"
    assert_path_exists testpath/"test.docx"
    system bin/"officecli", "add", "test.docx", "/body", "--type", "paragraph", "--prop", "text=Hello from Homebrew"
    output = shell_output("#{bin}/officecli view test.docx text --json")
    assert_match "Hello from Homebrew", output
  end
end