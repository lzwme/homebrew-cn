class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.143.tar.gz"
  sha256 "3e4851edbbc2c49ef832e0160536265a0d31c00fb28d4b104901e1b071d6011e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20c97ad944c9f95c991f9fa4a76f30d1de5e1e7d17b972fae7bfd395a14f685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4dbbcc4d218b8384a53779ed526131ca6b2e2ab34ecbee0aa573d403a9986ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88c897a4233d130851679c72170e42bfc28ba6ef5372480a3233cd849b891dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfd01d73b993224f0f639fe218fd8c2f1a21190abd228c64f7409f2b3d0b54e5"
    sha256 cellar: :any,                 arm64_linux:   "41704e3c781cc740e927222c4f0f50bf7fa1a07a6c9e0f7feaa010b330d137b2"
    sha256 cellar: :any,                 x86_64_linux:  "ca8de1f26aa50dd59032883c2a6977831a00d46ecacde087be6b4821c887eecd"
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