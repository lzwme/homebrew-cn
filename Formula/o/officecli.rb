class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.124.tar.gz"
  sha256 "7cb9380ca763c8d04ab85fc64c72e30713bed5d4917b6fec841d631bd91630ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7a7c6b6038caa7fa038e477f0d469830be1acc0fea972575092ed559e6eb790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174ab0992b34deec7d722042e4b8272d3a62867b32ac04f0f24562d4f2d3ea63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1a2d4b9ece966cd55ec81ebc559945e8860fb7298b214fe8def6cc17f73e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "6799f466148a5fedf79ae3c46f141cce5f4900ac20764d2e5b5c4147a7d72223"
    sha256 cellar: :any,                 arm64_linux:   "6a7c302a457d3941c04431c3328820e14ab30877f6bb0705794848304f2322fc"
    sha256 cellar: :any,                 x86_64_linux:  "6be8b6420def6dc00005b12dbb19738b3c718680f324226db922c55c858b645b"
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