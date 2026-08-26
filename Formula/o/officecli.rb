class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.145.tar.gz"
  sha256 "74e4cd5cd617cd8da93522bf689d340ba562c29c6eddf7353b6e4302dad995a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c231caf21536a86e0a8a36d3ef337e9537e9a1c1a17c462ccb7791fe725a6885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52497d3b770348a833c697bff284b3dcd3f1cafdb2758be6e05cff924c078de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ac6168b4eaec7b10eb6ee6a74521c013088f9c4c125b3e93d4f369c61d000e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0bc712b49fa4bc4c6355a6729106ae964a0485819ecef334c5371649bce800d"
    sha256 cellar: :any,                 arm64_linux:   "fdef4f7e4c1e403b13783c2ccca4dcf4875657364e4120e731a80c99c26fc8a8"
    sha256 cellar: :any,                 x86_64_linux:  "9a939e8210a7f6c8626b1e79e2bebd67f8e7835c59b6e06b4831d5efc6631a4f"
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