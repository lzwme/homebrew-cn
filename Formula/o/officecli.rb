class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.148.tar.gz"
  sha256 "96753740a62e9f4a2a093a9702b4eadb288fde66ac8014cc944009dbe3ce19f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9a96c83781e2e29a074b75bba28ac1bb0757aa1ee193610d6c2c3d4b017be49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "601fac92faa2ede558014cc40bd3dd95908deeda7fbf5ba329074c43d6068834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f02c35db3f5feeee56a72e5468f7147b4abdd7bb4f795fa17ea2675f5d802f50"
    sha256 cellar: :any,                 arm64_linux:   "04ad5a9542d836f98695135d8eebf61a998163e06fee47442af2dbaceaa3fc8a"
    sha256 cellar: :any,                 x86_64_linux:  "b1e3137fc89ab8c71d356e3168c1f87c8f6722fc654b811668b65c0fb40c07b8"
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