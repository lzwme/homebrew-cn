class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records"
  homepage "https:github.comnpryceadr-tools"
  url "https:github.comnpryceadr-toolsarchiverefstags3.0.0.tar.gz"
  sha256 "9490f31a457c253c4113313ed6352efcbf8f924970a309a08488833b9c325d7c"
  license "CC-BY-4.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "76cb31e149dbe88de67cbb6911e3837f7fddda5d773b9abc3b8374f770bc309d"
  end

  def install
    config = buildpath"srcadr-config"

    # Unlink and re-write to matches homebrew's installation conventions
    config.unlink
    config.write <<~SHELL
      #!binbash
      echo 'adr_bin_dir="#{bin}"'
      echo 'adr_template_dir="#{prefix}"'
    SHELL

    prefix.install Dir["src*.md"]
    bin.install Dir["src*"]
    bash_completion.install "autocompleteadr" => "adr-tools"
  end

  test do
    file = "0001-record-architecture-decisions.md"
    assert_match file, shell_output("#{bin}adr-init")
    assert_match file, shell_output("#{bin}adr-list")
  end
end