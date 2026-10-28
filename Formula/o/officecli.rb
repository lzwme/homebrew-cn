class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.159.tar.gz"
  sha256 "4446330b148d1f1331e5c83949c412165b29c5db628e9b7934fd0c6603bc02a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c103b0d48c552b50a4d11697f99a965044f1f5029f386cebeb92cce01249d516"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "223cf707a7e5dd28ba7052093aacd91519670893602c1a8a768c5e341713a2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1b3795b08febcb7cf7ae7f4b0de48e57f75650eaaff974e72fac1bc6e35f57e"
    sha256 cellar: :any,                 arm64_linux:       "49f36fa49d7b0e2441aeaac959860798ec87308ade43f9d916912399f557486a"
    sha256 cellar: :any,                 x86_64_linux:      "6b990a4e40276e21890f219833354fd0375ad525d41a39fc77dce95979ff256f"
  end

  depends_on "dotnet"

  def install
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

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