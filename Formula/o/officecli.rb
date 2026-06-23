class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.117.tar.gz"
  sha256 "e33f244b982b6690193f0878e14d1dd32a695d186f3d0f51cb41b7a350391103"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa29bf4dc72aa198fe3268d1d729e9fc7aebed2171dc90e1b9fa5ec4d1737ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb1ed2258be602ee49a7fa9b4c651fe5c4d92bfe70271060ec85088f89293f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604dfb98ee5fc734f66150965fdbea123321df3edb0e38967e9f310e3b92a2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6933519480810205c01e1d12478aa3ec14a2eaf5a72d28dbc3f642561129b5"
    sha256 cellar: :any,                 arm64_linux:   "24088217153d4361fa768e260e7f18ac515dab587b5e8ee36af5485f38b7d719"
    sha256 cellar: :any,                 x86_64_linux:  "5d3a3d13ff1aaded9f4b1a1fb0517898ddbe7383f1c4f9f90fabf2885c17bf84"
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