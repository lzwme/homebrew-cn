class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.113.tar.gz"
  sha256 "d40dc23504509eabb22c9a657dbc8e0add670520490ac0407e218aa1e29bae8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e775fc01544a92526d6f3ce00a8782ae9f5586f94d255b017a9387eba30ed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "667f477170e1ebc788286839d2c3e1f5b34d72edcefe48778175546655b90357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9eb2df8d6553132c04de63aab727b62d2f8797c520e2857ec3a494537951376"
    sha256 cellar: :any_skip_relocation, sonoma:        "66597ab1f45f1b07fcc7f056fb11ea6530063f2cb77c4b31aa6d0401cae1e238"
    sha256 cellar: :any,                 arm64_linux:   "842e8e2bea921e0527b23f6e2bb24a1589bbee780b5a21a5e1a3c868d95e6ab8"
    sha256 cellar: :any,                 x86_64_linux:  "78692faf1865b6518ad0e7554385729cf42a8c894e5728a74e4db802edb108f8"
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