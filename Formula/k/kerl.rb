class Kerl < Formula
  desc "Easy building and installing of ErlangOTP instances"
  homepage "https:github.comkerlkerl"
  url "https:github.comkerlkerlarchiverefstags4.3.1.tar.gz"
  sha256 "f1e761fbf49b08c468999a41684f292b943852131fe2cb68a76ea65aaaae9a31"
  license "MIT"
  head "https:github.comkerlkerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d34f3efbff5f758fdb3677a1c7465fdfd781af94c4b0c87e5fedcc364241f644"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completionkerl"
    zsh_completion.install "zsh_completion_kerl"
    fish_completion.install "fish_completionkerl.fish"
  end

  test do
    system bin"kerl", "list", "releases"
  end
end