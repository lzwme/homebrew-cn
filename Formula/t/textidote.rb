class Textidote < Formula
  desc "Spelling, grammar and style checking on LaTeX documents"
  homepage "https:sylvainhalle.github.iotextidote"
  url "https:github.comsylvainhalletextidotearchiverefstagsv0.8.3.tar.gz"
  sha256 "8c55d6f6f35d51fb5b84e7dcc86a4041e06b3f92d6a919023dc332ba2effd584"
  license "GPL-3.0-or-later"
  head "https:github.comsylvainhalletextidote.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "233ce6f6a6e226e5f00f7fada39dd51587afdb332e4c87f1ec9424e394d80743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b7818a01928aeda595a8a77e91004a75e587a95c0e02110e48980ec6afea0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d99486e4a64f499d54fc3ceb04e025c93c437ab84bccd09ea18924c0ed536265"
    sha256 cellar: :any_skip_relocation, sonoma:        "918182a20520b96b5dd635a1d0cb4d373b5368cc1776f1645786c06554e1f50d"
    sha256 cellar: :any_skip_relocation, ventura:       "14ef73a0bfd65f87b129c5ca365608322a019ce74f2717ed152169b692b2c5c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b8b47f1a6865eedba83b190e10721c013c31e1bedaca84b319aa4acc1c865d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820b5da9880ca2ce2b4c9251236314ef10be053b64c27b7a927325a8daf2591b"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    # Build the JAR
    system "ant", "download-deps"
    system "ant", "-Dbuild.targetjdk=#{Formula["openjdk"].version.major}"

    # Install the JAR + a wrapper script
    libexec.install "textidote.jar"
    bin.write_jar_script libexec"textidote.jar", "textidote"

    bash_completion.install "Completionstextidote.bash" => "textidote"
    zsh_completion.install "Completionstextidote.zsh" => "_textidote"
  end

  test do
    # After openjdk 24, "jdk.xml.totalEntitySizeLimit" was modified to 100000 (and before that was 50000000),
    # which would cause a JAXP00010004 error.
    # See: https:docs.oracle.comenjavajavase23docsapijava.xmlmodule-summary.html#jdk.xml.totalEntitySizeLimit
    # See: https:docs.oracle.comenjavajavase24docsapijava.xmlmodule-summary.html#jdk.xml.totalEntitySizeLimit
    ENV["JAVA_OPTS"] = "-Djdk.xml.totalEntitySizeLimit=50000000"

    output = shell_output("#{bin}textidote --version")
    assert_match "TeXtidote", output

    (testpath"test1.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
        This should fails.
      \end{document}
    TEX

    output = shell_output("#{bin}textidote --check en #{testpath}test1.tex", 1)
    assert_match "The modal verb 'should' requires the verb's base form..", output

    (testpath"test2.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
        This should work.
      \end{document}
    TEX

    output = shell_output("#{bin}textidote --check en #{testpath}test2.tex")
    assert_match "Everything is OK!", output
  end
end