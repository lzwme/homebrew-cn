class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.155.tar.gz"
  sha256 "60e182f6e753426a2f7276792bb62d00c6b1e3b2dd1a2e2cc2ecd08a4aa668c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b6ea26952b138590eada3169498977823db1684330f6dd9e08e647853957c5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51280c8f065e0f0efabbf59747c7473cc57ac47b781b8385cbfc13e1bb2eb4f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adf161bdb3c7e8ef158de7e585398d6e1f6aa9e9d84f44b8f46edbdc1d4fefde"
    sha256 cellar: :any,                 arm64_linux:       "4876d6e93a28bbfd5a82d0ee5d9572c448b8856f61f096bb202ad50a46e1aeb6"
    sha256 cellar: :any,                 x86_64_linux:      "7e624c7039d8353a77e81744635ec2c6350cd1010161b1195451f92908e780ca"
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