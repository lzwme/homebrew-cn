class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.114.tar.gz"
  sha256 "34866319b391120178c00add861d6c02a6ebe8d02258657755a56fe2eb260145"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d3645d99ba01fae17a8a1c0e2a293d8f2df251a54591e9c1e9190207997ae9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7491d1d264e836e422a1c80d32818953a0551b09b83e3860e8a83fea8d492882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ebedec8a4d8c4ec901645b33285a7f843e26c46ecd43d478d39038d0e597169"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7dffb237dd7f065ebcf83a07a6f43b9f2e826958a25e1e7fb4068b623313952"
    sha256 cellar: :any,                 arm64_linux:   "4131e53b86cfa33d2706f8be8e77994dbc0bbebab0227b318249769bca348219"
    sha256 cellar: :any,                 x86_64_linux:  "6d543ccee6ef9584442544297b2365a4e167c8ec2c334256108be04cd47d6655"
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