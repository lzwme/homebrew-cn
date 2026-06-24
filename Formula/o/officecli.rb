class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.118.tar.gz"
  sha256 "d29f15d0131a5a7e8aaf4fefca620566145a9c18f677cdf53c0af4dae99e25e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ddedb9c70acfe5162083b2898c178841c9572fe1d4a357bcd34495195c43e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05868584a09a7dcd730d3a36175f50ff07fad667ffb3e4c104736b1cf417476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19854aa1b93a6ff5e711fcaeb997dca6084bcf391e3e986aa87301380c1178e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0a4456d64b3d3666ee381375aba8a948b96eeabe6f934877d612f48bb07a8d1"
    sha256 cellar: :any,                 arm64_linux:   "fad64521dfd1ea689b2923cb6abf9fa8995f39b2357070a24e1e94a99919822c"
    sha256 cellar: :any,                 x86_64_linux:  "450d0cf60209dff67c391c8ca39bb1e5581c07914e9e6e7ec9a65d9dc8a8c759"
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