class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.146.tar.gz"
  sha256 "124150eaab018ae6f6acfabd45ca7174669da9e77ea81373e1c795d93399b195"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836187f1d668d092e0bb76ac9e52b9e1cf4c387605c343034426242575ab2e13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97e06b8a7048e1f33c51057da882bbbe40a622727c3116563537d08955df0df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72fe6f04b3ee763a5b05dab37f8007a4311533220db9ad85c837eec910746222"
    sha256 cellar: :any,                 arm64_linux:   "20b316bbec88ad7d086194d7c04614cd041fa3bad256b55086b80ea9fb261e0e"
    sha256 cellar: :any,                 x86_64_linux:  "e30c349a9f2779ea6245d16818cbfe9aabcbc68784e4382827ac060ba77d8f79"
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