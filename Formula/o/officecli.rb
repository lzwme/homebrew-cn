class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.138.tar.gz"
  sha256 "ee8b3e17241e63290e4b6f0da9f7acf8bff8fc969022262981854b9afeae2e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f4b9598de5a9953fa7f2b552d58730a17be488e08d9dca396b07aa7fb04d481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd5e0e8022ce9c0eb7bdbf626af31a1982b1407303cfb0cf393004c41d72a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8848b2249f668eee819186855df70b50200b3f02401aad87b3136c307d87f7cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "71fa8775fc61a96497d24d10a719ee705ed89707f2cb41c682b1a5340781f691"
    sha256 cellar: :any,                 arm64_linux:   "dd38e66ceb336fafbf8124d45415a00fc0b402b023abceeb9080bd86f7d1d256"
    sha256 cellar: :any,                 x86_64_linux:  "7c77887ca2cbc92f901c7b0b0df2a3d3ae097ac5dfc16589de557b3c00006094"
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