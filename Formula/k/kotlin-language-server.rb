class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editorIDE using the Language Server Protocol"
  homepage "https:github.comfwcdkotlin-language-server"
  url "https:github.comfwcdkotlin-language-serverarchiverefstags1.3.9.tar.gz"
  sha256 "4c06ce35b1686c27cc4a8b8dc0905dd3901e83de7028e0c7c0cfd2b6082e1e09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e91930f40bf2bb3c67923ebd5b2f805a0563499472e31c32aeacb51649eccb07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db29b8f517e0a0cee65748dd6b5debf1496c1da501b4316ee6cee2247eb2dd61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d64deb69633ac52c2fa1e95a354edcf13ea64a49d3811af229b623b8e8a152"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a26da8c4595acb513b34e161a7386910aec941556706c52bc91ce97cf74896e"
    sha256 cellar: :any_skip_relocation, ventura:        "772a25d2c6459c9c749606527e0dcb72e822e7dd2fbb49edf7c520aceb814cec"
    sha256 cellar: :any_skip_relocation, monterey:       "9def5cd2897b3a4f0038a248c4f8575be3ceedbdbb9224a5f7563831c4c4dba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a55f105ac7e47698557983f8d873343206d5f0d4c0b049bbf47ae0ff7a2d2f42"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist", "-PjavaVersion=17"

    libexec.install Dir["serverbuildinstallserver*"]

    (bin"kotlin-language-server").write_env_script libexec"binkotlin-language-server",
      Language::Java.overridable_java_home_env("17")
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}kotlin-language-server", input, 0)

    assert_match(^Content-Length: \d+i, output)
  end
end