class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.141.tar.gz"
  sha256 "e2b13b7c76ff78dfb1914a925c9bda3d4264bccbcf2efdacf1e45aa311f898a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "199bce2433e470ee6171c2f2a525a27b56c4b3f35f11b493b7a0e8de4fa0fad3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1ed595b282b19cb49fb54154b2d4369d271c24c2276c2213d94c7d16b6c011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a187152bff4df13c9b808a6e126a88feba0103fffea423d211b34676d9b6ec42"
    sha256 cellar: :any_skip_relocation, sonoma:        "a165c0be44ea99b1e1da963a9f5b0e05dd26fb9b83e61fba109067634b9e0163"
    sha256 cellar: :any,                 arm64_linux:   "8ae864abf118ed691162c46ed986fc619481bb7d83f15c071626d354e7f640fd"
    sha256 cellar: :any,                 x86_64_linux:  "10d4415b0f14ddf1e1c81ef9305173c0b06feae246bb50e7a8673093d606abac"
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