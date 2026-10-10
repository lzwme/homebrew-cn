class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.156.tar.gz"
  sha256 "23ba26bae0aeac0a3ea753c9723e41b4a709eb42f7cbbe9f5a859f8d9d2ee421"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0149d73bb712c8c23ae73d93f6c483077f9d5af73ee6051908e6046d4b6bafc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f5dc2d801c7bd1cf3c0defbbec93a2dd0c938c6501f8ac98c92753cd0dc548e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df8f32745e46c1324bf1c6e88cf1471eed0a50e5aee197b6a5c6df9c9efcdfb3"
    sha256 cellar: :any,                 arm64_linux:       "95951a07b02e8422aa530646543bb7c46cdb47cc83af206722bb52d688eb8d59"
    sha256 cellar: :any,                 x86_64_linux:      "05cf36c9d4a92a85f4b95736b4ad148e14a120cfe16fc2cd8c7c02a863db6d79"
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