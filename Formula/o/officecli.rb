class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.127.tar.gz"
  sha256 "65dd2bf98a0dae1d00f619409ccce671bf77400ea4f493a519db24b511d25788"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cfa1d2b69538cfa04011d5ef326718da26b44c03f8d1e9e5a382c3a9601847e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd49b6a5f5b6759c9f8f7886caf85c0f22346905030e20a0ea192231700b6f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb81640cb8705fe3590c46a7a202641f1b92b43819f4ab6cd5ffc0f89e9845f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b63be05142d7d2f53de8bfc4e33dfa708637a02f745b65649adaeeee65db9a1"
    sha256 cellar: :any,                 arm64_linux:   "4e05ab9a52802becbb717d0b368904a6c222005750024b88bbbaa7e0e56b4bd8"
    sha256 cellar: :any,                 x86_64_linux:  "6fc4a16fe5c09357d6e1e52177b9e50b7447855cc923e516932bbd9b275898b2"
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