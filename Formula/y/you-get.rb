class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https:you-get.org"
  url "https:files.pythonhosted.orgpackages42f3c4bdf49e31ac1c6bc477711a4ec6a276ae0745a3b8fb143c161bf32e8b49you_get-0.4.1730.tar.gz"
  sha256 "65457b7b8893f08c082532eb34998dc477f533d32568be3bb34e592bdcb44f88"
  license "MIT"
  head "https:github.comsoimortyou-get.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19a25f252fdf9e745696c92b25e2f94a68c35a14bb5abb5d9c9173bbd2b88f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b69e1ed11567beb060af0dc1ca6b866a50d0852c7462cc5171a59946183bfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbeb9ccf0eeccdbd16b292d3845af8870d04a98580abe63218e6719fd8e9b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd18933cb33bd106f69dd548b93ed663ce3cb408eab047232fca5d6b8d46fb38"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3e140c94f095b8fc2bc91382a75ca76f639bbef56c9be89f5f70b31e603138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307a7aa5cf2a671b668a8129406d209ad209872c16bd511c4ba969a8fc54a0c7"
  end

  depends_on "python@3.13"
  depends_on "rtmpdump"

  resource "dukpy" do
    url "https:files.pythonhosted.orgpackagesd10b402194ebcd92bb5a743106c0f4af8cf6fc75bcfeb441b90290accb197745dukpy-0.4.0.tar.gz"
    sha256 "677ec7102d1c1c511f7ef918078e8099778dbcea7caf3d6a2a2a72f72aa2d135"
  end

  resource "mutf8" do
    url "https:files.pythonhosted.orgpackagesca313c57313757b3a47dcf32d2a9bad55d913b797efc8814db31bed8a7142396mutf8-1.0.6.tar.gz"
    sha256 "1bbbefb67c2e5a57104750bb04b0912200b57b2fa9841be245279e83859cb346"
  end

  # Fix for compatibility with YouTube html change
  patch do
    url "https:github.comsoimortyou-getcommit1c9c0f3ed1b8466239fa8656523658ccce8bb489.patch?full_index=1"
    sha256 "3f00c40cde45e2e05a0a2704781e6618667fe71227dd6c42edd6ff8eb5a81e3a"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "contribcompletionyou-get-completion.bash" => "you-get"
    fish_completion.install "contribcompletionyou-get.fish"
    zsh_completion.install "contribcompletion_you-get"
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}you-get --version 2>&1")

    # Tests fail with bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"you-get", "--info", "https:youtu.behe2a4xK8ctk"
  end
end