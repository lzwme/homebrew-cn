class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://ghfast.top/https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.125.tar.gz"
  sha256 "f0de5bf5c764c7b75d9346898285d1aba1dfb998c7f2b6cdbd4b24d07838654c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "084aa83cb1920cbaeb32e389c1237eecbebe947e86d8bcff0da903a7503c02d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c957216f7e91d8181658d06e96a5a34b8bd851a748aafbfe332c110e9ebf8874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "481a2d42550cd3057ead95dbea56fb73e6348f955faeb1ab756e03ee4b032a88"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4ac8935f1dc94f6f1289f8dd65e13f4dd22b6866f6e13551637dd3d1d83dc5"
    sha256 cellar: :any,                 arm64_linux:   "0d68bb7c985ce5eaa0ca922807ffd53584ecd92afbd6758290618ee2fd678b22"
    sha256 cellar: :any,                 x86_64_linux:  "a96d93a5d72425a7486621b3e212d978e58aa03c7c00b819adc26315b0114096"
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