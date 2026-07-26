class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.142.tar.gz"
  sha256 "13dcfb21485be5b4f64c13d0e4dcea30e83c98989d0a1e8cacb3a4dc28765f8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb46f35e430011dc5cb31a04edf3eebefed79278bce5c380f9047180d266e5d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e2d6523518e484da1a55d5307b44fdf8dcd7204b163f60f9ff9667f1f0b754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb01f890571b31a0a68c581035d0214e36993253afeddf23cfab019de134cfa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b532d51932848f21d0699e9f827d9927c1ad1307891ba0f70d4f581fe498671"
    sha256 cellar: :any,                 arm64_linux:   "0a078b42e60a45879bfdf9461e369fb0512faa122ff382782073d63ee85b7b29"
    sha256 cellar: :any,                 x86_64_linux:  "bffa2aa30632a4bbf2370336468de6b4df49e5d46ae7e7c79382ba529289e089"
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