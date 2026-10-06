class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.154.tar.gz"
  sha256 "82c84cfec2f9679ba3a575033bda46612856a517984dd0d3e529165e09cb1c1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4081c5ed420a0e47951e4b362d6c4e300e87320a6333e3e20377dc791231347a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8f12570264be0f4588fcfa7f9f2efa046e33d76ee8a1b5b811d895adf55a6b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e87e9c38cca75c71015faacf32ab46a70934d51172d3cbadd525ddc03098beea"
    sha256 cellar: :any,                 arm64_linux:       "9db099c68660ad962e844132327e2102a2916d1e024647e3a3d70593f0840353"
    sha256 cellar: :any,                 x86_64_linux:      "8faf828fc4d67c7920da021e35bee060d21ffee44c622f8fe50942919b478f67"
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