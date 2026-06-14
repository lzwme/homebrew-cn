class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.112.tar.gz"
  sha256 "5fd5c8cbbb7facb5eeac7978ed78412f53833959bd21e44804a9f88d7b307e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad9aa67805703aa3af38e9844a220328414d8433ac7794981a7feeaa5930ce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e559b13676dcc725481f7d514ad7e127ff63331db72f410ccff77174b3c340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2af771344b56f2a6c98bbae02d819d409a96c27006550ad6ff15452e279f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e111c73ff03846a15bdd3ea63cad1a17563b58948f11b991b135e5a6e63e27"
    sha256 cellar: :any,                 arm64_linux:   "8f3aa895f3e292335b64fe07ce0b4b49dfc702fb38158b333b7c44a7db1f0705"
    sha256 cellar: :any,                 x86_64_linux:  "fe6cb29b91142ba5fffc53d0c04fd49334a682256b6d0952a79d17afc57eacb0"
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