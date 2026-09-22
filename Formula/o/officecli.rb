class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.152.tar.gz"
  sha256 "99f8ec827063398dd226169498fb7ecd28d958c82210f81c2fd73765ed6af196"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a837a9b9109a984e843513c41c5eff13819771f8d55784873bdc3a5e48f30c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff313b888374aa039e729f7412f7466a60730b54fb81ae0cb5aba2fe351fd5b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df892adb5badbfa0b5db03dec63bdffab7ec3683dc05949898c72397f34b47bf"
    sha256 cellar: :any,                 arm64_linux:       "f0eb5416950860f09d816dffc66ff8464076d9c2344f0de720b817aedc25f409"
    sha256 cellar: :any,                 x86_64_linux:      "effd19205eefd93da5600b03334bdccfbc205f2b24244b6378a197ca9e30f2f9"
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