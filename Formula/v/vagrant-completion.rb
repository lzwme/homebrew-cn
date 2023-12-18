class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https:github.comhashicorpvagrant"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https:github.comhashicorpvagrantpull13248
  url "https:github.comhashicorpvagrantarchiverefstagsv2.3.7.tar.gz"
  sha256 "fa8a96319aa7b9ff5f4a991b77cbf37f549549d84737624bcebefa8f2004bf45"
  license "MIT"
  head "https:github.comhashicorpvagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e505842b21fff086e13163e635da612316a8d1c3ef598744f773996c692ffa3"
  end

  # https:www.hashicorp.combloghashicorp-adopts-business-source-license
  deprecate! date: "2023-09-27", because: "will change its license to BUSL on the next release"

  def install
    bash_completion.install "contribbashcompletion.sh" => "vagrant"
    zsh_completion.install "contribzsh_vagrant"
  end

  def caveats
    <<~EOS
      We will not accept any new Vagrant releases in homebrewcore (with the BUSL license).
      The next release will change to a non-open-source license:
      https:www.hashicorp.combloghashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https:docs.brew.shLicense-Guidelines
    EOS
  end

  test do
    assert_match "-F _vagrant",
      shell_output("bash -c 'source #{bash_completion}vagrant && complete -p vagrant'")
  end
end