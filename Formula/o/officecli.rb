class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.128.tar.gz"
  sha256 "95ecfa1011aa5fecfba4593c9e16d5bf555a829dfd0337687f8fda463d4b488f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2028bff6bf3a387724b26b78a24bf31b6332981b73ff5a61ed8b60347c3e5dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9dbcebe4a264d42ba6e735d6b2142610f69243c57b9c656933bc2c8886bd31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da3d1b501dba74c3fd74c77282a27e4457703e4459c92399e80b9ec55907b954"
    sha256 cellar: :any_skip_relocation, sonoma:        "514d2c51298d6b8135b2438955c6246b14c9a31693f1f0819a77e98659dae31a"
    sha256 cellar: :any,                 arm64_linux:   "7afae9c8b79a41659f39951e0acd2e8f946fb7d53e1a3e9a0f4b089bf7bc795a"
    sha256 cellar: :any,                 x86_64_linux:  "a14966b7ecd170ed6ddd61a8a8df553f086f1da2d20e17a1494f12f3eb8c474c"
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