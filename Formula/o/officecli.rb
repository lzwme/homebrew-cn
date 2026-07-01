class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.126.tar.gz"
  sha256 "3dc1bf984122424f56062f98020fd997a827fbed05ec1865ca77c4da2f0167d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c73e702bf1350624a6d8961a3b2e1084892299c4ccdee3b0053be3d78b27f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b873ae88f81e53f0587a587c8959183f6dfc1826d1835353a3ec9ed9ae6ab6a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2009e50240802fb23c004dc7d4ff7da786db307cfea2e40d1bd9fdf610b93d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f3b1d1f40b272c51e72ee59f726e64e10a10bd94b60f251c44056f72910819"
    sha256 cellar: :any,                 arm64_linux:   "68164af109874b0130d6e383595a7ed8a883b99ae3243779ae52ddbe8e3f20b2"
    sha256 cellar: :any,                 x86_64_linux:  "9346adaef487963686be5e96caaa84a27d7d5a449f8d6fff484ba4317546588e"
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