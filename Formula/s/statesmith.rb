class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https:github.comStateSmithStateSmith"
  url "https:github.comStateSmithStateSmitharchiverefstagscli-v0.18.1.tar.gz"
  sha256 "717f83f58f8a12c6efd1180082b99c80dbab47dc21ae3c401842d2421bccdd53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1576f1684b5f3c71da50c27a0115b10c19730eb7c692352ed3ccc01520f9439a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae6c6d082cfdc2aed41e6da7283e8daff7cf31ee8886ae6d993f703342237a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3515a7b0faf682bd995588b85dd7c85412246cc7b13fcb69ec3f444ebea56774"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4af9949d17eda049704c3c42ff69dc19b16e24cb16130c76c07ee8e1d64319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d99ffff23a0b6c5b8fa284c0c0854d8f99cf65e1c4955c368c8bd5c595e0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162ea85fb02f74674f654ec929683af210d1868afee2dddd9ea271f98d112fe6"
  end

  depends_on "dotnet"
  depends_on "icu4c@77"
  uses_from_macos "zlib"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      -c Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "srcStateSmith.Cli", *args
    (bin"ss.cli").write_env_script libexec"StateSmith.Cli", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    if OS.mac?
      # We have to do a different test on mac due to https:github.comorgsHomebrewdiscussions5966
      # Confirming that it fails as expected per the formula cookbook
      output = pipe_output("#{bin}ss.cli --version 2>&1")
      assert_match "UnauthorizedAccessException", output
    else
      assert_match version.to_s, shell_output("#{bin}ss.cli --version")

      File.write("lightbulb.puml", <<~HERE)
        @startuml lightbulb
        [*] -> Off
        Off -> On : Switch
        On -> Off : Switch
        @enduml
      HERE

      shell_output("#{bin}ss.cli run --lang=JavaScript --no-ask --no-csx -h -b")
      assert_match version.to_s, File.read(testpath"lightbulb.js")
    end
  end
end