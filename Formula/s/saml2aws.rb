class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.12",
      revision: "d088a19d30434f8fa0a403d0b179103309d14e82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c560f03160573bdeb50ef15c4c30001526d2a476ce91c1880c4b4f7bd08f6ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a335ff14a2d470f01e54a5b855292af0d33a0ade1650691a86187a27922bbdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b42fb2ea93d17ecd7ba148897019f26946f3e36ac18cc575760340572c8f1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f147444bfee2eb649d3ee756a8323628d1fdd84dfdbc71c26e3ba13391050f4e"
    sha256 cellar: :any_skip_relocation, ventura:        "ddc83d3b60328fe6dbf1b8e3e25f7e7771762a4766c10649a056865c173a98f4"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9c6fefe13ef528aea06672134b480262c2a9a6181c7ad815284345ca8fc0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa43bd6b55a457d70fe76611d148e96b4af268dceddbec18a32c89059a4ce96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/saml2aws"
    (zsh_completion/"_saml2aws").write <<~EOS
      #compdef saml2aws

      _saml2aws_bash_autocomplete() {
          local cur prev opts base
          COMPREPLY=()
          cur="${COMP_WORDS[COMP_CWORD]}"
          opts=$( ${COMP_WORDS[0]} --completion-bash ${COMP_WORDS[@]:1:$COMP_CWORD} )
          COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
          return 0
      }
      complete -F _saml2aws_bash_autocomplete saml2aws
    EOS
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end