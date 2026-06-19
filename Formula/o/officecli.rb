class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.115.tar.gz"
  sha256 "fc823124a3a7f0918b1dc51010bcff6c1e25ea0276dcdd7e36b5531a0c5c5d84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "670dc65f2b33aff4798e9712acc54768bf3b8540e3c5d228d55ff31635a4d228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08eae2f78464a40a81e4337a984130b843f1a1d23b3dfd898638f3ea20eddf69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5957207d64c84d11a66fb02ccd8ad054693dfcaa44bc329888d531fc619c089"
    sha256 cellar: :any_skip_relocation, sonoma:        "2695363ea5221ae7b05abff8d91577dbe6e66dfa8186bf700e3fd1f9d95db674"
    sha256 cellar: :any,                 arm64_linux:   "cf2785aac28746bd8d982991978b76b0a5fd0dd79bdac9442c505a588c43243b"
    sha256 cellar: :any,                 x86_64_linux:  "1c562a03000e5cea70a54d332d68c604f5d4f215af08cc7c4768bbe98b5146a3"
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