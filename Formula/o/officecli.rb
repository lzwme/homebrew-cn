class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.121.tar.gz"
  sha256 "6ea630f2d4f84b88cefd0a326954994ccc0f30ec407a84608fb7e8c6405dbceb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b3861033ad0199814c11173f0501b3b02bad7dfa804ef3fcbfbf4be8bb2b19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdcf192d564c61cc2b66814e4cef3e4ef92db57d5e999034bc216ff359f01ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46def8a0fbb217e64e98eb8b576da082f799b180d36e8a9d4a48297d4ca559c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e513c56cd6a904184b780c5f61ca764d5c4dd347614b70bc69bebc0e8596526"
    sha256 cellar: :any,                 arm64_linux:   "effd815bda0b6f58403131246ffea222b2c107864db268e41b9dd77737128eb1"
    sha256 cellar: :any,                 x86_64_linux:  "87bdfb63ad6f046c82774f85d67d8b308518dc998a67f43535cef3645dd0924a"
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