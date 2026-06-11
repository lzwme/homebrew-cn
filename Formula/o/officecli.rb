class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.110.tar.gz"
  sha256 "6b372d9dbc264d355014448d4e25ccba1ea06a72c0e1d4c131f351f9f60e82fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1df3635468a198267348af2189f16012a8ad32a7450a41a00b8a5a4dc64bf2c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1552e13639b46780b96da9505aa67f675ddad7665d5c3ac08707bd40a2eb08c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f67291120d5091d5db2430644c96ee27045118842080e1a33b2808adcf4429"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f77dd415b20b9af30b59e2f84c1e5e94c89b8cc0c90e1106c39a51fca9e82b"
    sha256 cellar: :any,                 arm64_linux:   "74391b3f87f32785fc2400cf7b3f0b46ff91d3cb0f08a5061718ee925cfdd856"
    sha256 cellar: :any,                 x86_64_linux:  "092cd43eb8ac267f149e2d6b8340885d9acd67d37705b18e30fd24f737a60912"
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