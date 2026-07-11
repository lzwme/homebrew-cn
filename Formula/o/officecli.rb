class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.135.tar.gz"
  sha256 "1de83a57d3f66d4c23630cae4da1dbbdfdaf56394f7bf5ac7428f761aedbb341"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17815e263c7da0f5ff90d22b93bebca6e143f0600eb961320b286ea444aa7e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15c6518665758f7f3f3a18f1fb7783d56147e2788fc99a4bbf104d1683e029a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a7a8a0d0ec3244c919c11c9d4a173a4bb7651a8432a72b11ed3bc44fec27e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "91499d963b33b17b8bd33b9d2c8a00fe80262291529dcca6fa9f5915ca6997b9"
    sha256 cellar: :any,                 arm64_linux:   "f600a63388f1e72ab35e0657dfceab74ee96df9edf93dfc78ae9fc2f401ca0eb"
    sha256 cellar: :any,                 x86_64_linux:  "41e3e92e097b19eb6a240ebb22537d68f619a863918ab460e9914f9b14cbc7c5"
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