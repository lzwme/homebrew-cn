class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.153.tar.gz"
  sha256 "3af81e9bcb703bef2a6c49556eda0cf1558eca7c396f70cb996a25c44e1af408"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d08ec72611f12367f91a5ac7e6dacef12c23b2fb6d10504d5b6dfd5fa30d4071"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "266c5d49f5a87b8d10cf35e20f0b17276a6a4ab90b3442f4b0e72874885eeaa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00a93747022d414907ac57981fc369a9e7612bea7459f20c03715015baabb937"
    sha256 cellar: :any,                 arm64_linux:       "d4446be9a0d53e4b1f6fe5970d583c37e821e3fc55185bc856efb8f8467d5762"
    sha256 cellar: :any,                 x86_64_linux:      "27a219e3d32330651eb43f0e5e28321594fb9ff69f14f19e0c007b02c6dd9e69"
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