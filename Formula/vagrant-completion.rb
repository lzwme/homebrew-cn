class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://ghproxy.com/https://github.com/hashicorp/vagrant/archive/v2.3.5.tar.gz"
  sha256 "34fce02219c67174457a6f8750063047f6c29b7148e425e4f3647cb80b8a5b2e"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d1c34002557f69a513a7e1551cde4d2218f149551ea6cf8194b99678239de8e"
  end

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("bash -c 'source #{bash_completion}/vagrant && complete -p vagrant'")
  end
end