class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.111.tar.gz"
  sha256 "767bb04354dfe0ce0ebd97537c05a03180fa0ec677c0a8e66ee1d5962594d1ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a4a70bfa45df8fdfd67342309ab10885a437a791d37bb0ba221eeeb6db24491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2637f985c49a53100b50394fc211f6d8e1456c607a6b6575b0efe415af9188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af94690797af5c1e5b2f552f1e3fca7fbc35adb91e99ee944be65d8f04fcd4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad504ffec9603f92c159d33bfe50131db5de2b72047b17840e9f8a51f0a9c35"
    sha256 cellar: :any,                 arm64_linux:   "0f437610ae755a0513e5e495a51985b0aca47a16adcd4397304b99b52a9faa9b"
    sha256 cellar: :any,                 x86_64_linux:  "cccd197cd58c38b017e8c4d7d7767059fb1794a889570da88ea34f58ab9d13b1"
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