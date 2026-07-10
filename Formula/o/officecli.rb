class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.134.tar.gz"
  sha256 "39b223654e597ab200a78b03b2988a87c2cb7d2a113aa1778dcc4275a714035d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66dd8a7ae8bce2ad9ee3bc6047aafdca0867bac1a421b13adaab1c9e755b2a26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c32d00031e3c795106ca08c5fa1f4ee7ed6cb466623def8fff833f147af64f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "196ec996d0d27a6ffa7ff2f3d73f89fcc277b57a2fa12fb9543843581f628fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eac990f232522a6d909c28a2149ac61ad812deab8df507ae539a98400679016"
    sha256 cellar: :any,                 arm64_linux:   "38b48cac505007968ed73c551a12faca0ae422f2057ffc82ee26e36a3808b6b8"
    sha256 cellar: :any,                 x86_64_linux:  "4860a7befa3acbe3036b57e80b100fd5673a5e28e1df9b67a26394651adf1f4e"
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