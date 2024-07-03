class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https:www.apibuilder.io"
  url "https:github.comapicollectiveapibuilder-cliarchiverefstags0.1.51.tar.gz"
  sha256 "8b97ea24baed5689f645f6031dc57e8e14828e8d41b26a3ea18b1e96af248a7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, sonoma:         "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, ventura:        "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, monterey:       "2327c4b4cee95eb6aaeac46442e630fc429a8aee8587ae1f0b62c5e17c69f318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e345ef6cb2003bc1c8e8d3e2ce58760f87cd9c4810ae12af555ae7ec89b437a"
  end

  uses_from_macos "ruby"

  # patch to remove ask.rb file load, upstream pr ref, https:github.comapicollectiveapibuilder-clipull89
  patch do
    url "https:github.comapicollectiveapibuilder-clicommit2f901ad345c8a5d3b7bf46934d97f9be2150eae7.patch?full_index=1"
    sha256 "d57b7684247224c7d9e43b4b009da92c7a9c9ff9938e2376af544662c5dfd6c4"
  end

  def install
    system ".install.sh", prefix
  end

  test do
    (testpath"config").write <<~EOS
      [default]
      token = abcd1234
    EOS

    assert_match "Profile default:",
                 shell_output("#{bin}read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}apibuilder", 1)
  end
end