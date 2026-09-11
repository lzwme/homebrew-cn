class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.149.tar.gz"
  sha256 "7a4ca4c0e91318d7782ece14e0386fee967d6a221ead9ce3fd7d7c1f99cb7b6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df73565eb0c5991043e85d152b3699577efe245c55665d33d361e8af03c43166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cafa4350a7b4e30ecee7026f03b0cd2803f07a8b340c068507c72643d9514bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "303398deccdfcf57c6a2dcc06d7e6b424ebd66c54cbd0d7fc88b9c9bbb427f4a"
    sha256 cellar: :any,                 arm64_linux:   "1b2566f166cde44ee96ad2c075815acc515484d9e7efeb4ed582f35d41af49bc"
    sha256 cellar: :any,                 x86_64_linux:  "0af8c1743054f334ecb1768e76be620f013dcb04c99cdf10c299170b50ec30fb"
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