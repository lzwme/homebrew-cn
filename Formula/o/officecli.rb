class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.120.tar.gz"
  sha256 "c1322e07d522fb83fa7b1b78fcaf7707d04b1519764a181964a0b61c4ff923d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa21936dfd798c45d39f06f24ed431bdec635e98736edda00a0175ece983efb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a654e31537df5d811187cfc61142a6c8e205720d513ac3c91bbe59de9f3113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c1ddce38186b5c94e908c32ab0f1bad9e29b5721b11cb9dd94612d3914f95a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e77092427eecbd6eb813f72a05e4136c3610ed889b9fffe731f35522609db8b"
    sha256 cellar: :any,                 arm64_linux:   "7a729ff0470b25d7b17e6ce66b242c016b59ded751ce435cc9b945e263a6dfa2"
    sha256 cellar: :any,                 x86_64_linux:  "bc5cf3153796953efc88770cef2524fb74e0de69341c59a510324b3e626a8523"
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