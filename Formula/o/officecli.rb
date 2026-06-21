class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.116.tar.gz"
  sha256 "f3271f33faf858dad8920ac7af1fe8a41d362b3a80564f9806556c01b519f6f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "426a25c31b407a5ca6db7afdfc7900145da944818110a50f233caad4ec1a249a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e859900bdb307d3708c7ece49e6ce05bf2576c78f7b8647a62a8826cba5934a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d15aa52b7f3ff2e1366538394edbed6a2403de70cde71c133f8572347b807df"
    sha256 cellar: :any_skip_relocation, sonoma:        "367cdf334bcf5a8b247e69737517241fdc296264a54e35478b44d676ed18dc9d"
    sha256 cellar: :any,                 arm64_linux:   "96a399e2cd7096d2f7f88b069cd796be0eb175f43fe3971c6ebbd954172e33dd"
    sha256 cellar: :any,                 x86_64_linux:  "f9f7f2453e14c8ae5848ac9f00fc2cc67d9097ae41d62e636bb6ab2fd3b90651"
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