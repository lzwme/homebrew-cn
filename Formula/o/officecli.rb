class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.158.tar.gz"
  sha256 "5a5e7c3b84384e5db6519f0db4946f58aacb7359ff031ea52c127bbe1e7f0bc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f2682e293ff5480e87766efe5639113ea7c3ca729f2a8422e225f078205749e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47ed839540998af883ef9baacdf9c65f3e1251671fb4a9e2ece9dc0f4d4fcdba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fe9bffbb1489e2e7bcdb590bc5d5e54eaab621ae89eabdad49bdaff5e0498ad"
    sha256 cellar: :any,                 arm64_linux:       "1093d5965f4232d4f922d652242c859aa9b85d027c4e813fdf383406e5f284ae"
    sha256 cellar: :any,                 x86_64_linux:      "abc16eec31b637cf157ec899dbddfeba7c39568a60ea1d0a32539458912aa9b5"
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