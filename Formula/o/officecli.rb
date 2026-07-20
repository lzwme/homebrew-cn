class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.139.tar.gz"
  sha256 "f182698c90fb108de1ab2298d27e178eda8304d80caac5cf430eaa47b51f5a7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9e4758bde8d5ddcfcc74fe809a813f3490d274c980cd17b3d898536174a3c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d789ce8d9fbf829e11aaf3fdcfd7275af19af451eed36e63fd1fedf9b3c2685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e35731b3790a326ea72a407e46e98b3af915186e49683182e39dd993e0fa0b8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0a8f52998609f7b6290c6df9f8c9049a52f4fd71e6f7a0ed8774fb5d9f8caf"
    sha256 cellar: :any,                 arm64_linux:   "48a3bb8d878a1c89960b070c0d6e48b8f17a481fe3f7a70f822b6d15c5ba5830"
    sha256 cellar: :any,                 x86_64_linux:  "427506c4cf56982f0b678374d41be64f6bd7eed75eb189f8ca13d7ac316a0390"
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