class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https:github.comspaceship-promptspaceship-promptissues1431
  # homepage "https:spaceship-prompt.sh"
  homepage "https:github.comspaceship-promptspaceship-prompt"
  url "https:github.comspaceship-promptspaceship-promptarchiverefstagsv4.16.1.tar.gz"
  sha256 "15e6834ad464f57ef475fd880454b0d008c2beea9af0ad644df89962b595d792"
  license "MIT"
  head "https:github.comspaceship-promptspaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69e858a3de1d8635970c03a48f20578d765ff17813c98bcac6de8caa7632aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3720bd2d85501bc182ee6de0aafb7d3ea64cecc8b10f05174452393b7448f229"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4302cc00eaf7cae05cc2fc0d6a2d79e4ff131322e7b34716488830f001382b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "839c90899696703d56e3c85c8f57ebecfaa0972d55346e69f793a439d016bd2d"
    sha256 cellar: :any_skip_relocation, ventura:       "cf4bace6d2ae2e68716acdb7c599dca624f49f7f9f7282239dbbb03447aaac3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a431aa02bc2ff2360a69bb5866c399b670b778bdfd553f629c5548a89bf062"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~.zshrc:
        source "#{opt_prefix}spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end