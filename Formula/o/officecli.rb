class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.136.tar.gz"
  sha256 "3adcd8ddf20f3af362a00105936d0537bddd1da87e72fc18a1cee40f1b14b689"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ef0672de008fffb17ffa2bcd238d8f4ca28844543403291c50a555f46a76d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70c9dccc6b68296585983f08cb6d5f1344fb5fd3dd38b6ce890ef2a600c1b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c281b478d6510226fc3e43b33e602387507e7972b44f31caea7f9aee1fad7b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac2e863c9696a9f9908e81efad8d53a783f6ce00a1029d5eea3d8b7f9a8d4755"
    sha256 cellar: :any,                 arm64_linux:   "9743abe4d5e2b2188be5844b21d57444d3cdf682f795558468f8a74ec4541353"
    sha256 cellar: :any,                 x86_64_linux:  "24f74c87271af28101ce55519016491c5a8dc6e280cc53825a847a040b1e2eba"
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