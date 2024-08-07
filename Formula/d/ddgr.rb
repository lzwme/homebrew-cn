class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https:github.comjarunddgr"
  url "https:github.comjarunddgrarchiverefstagsv2.2.tar.gz"
  sha256 "a858e0477ea339b64ae0427743ebe798a577c4d942737d8b3460bce52ac52524"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3ae74323d821c1713d3a9df8c38a26e5286488dc1f5fd3cbe421cce82f489c2d"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "ddgr"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completionbashddgr-completion.bash" => "ddgr"
    fish_completion.install "auto-completionfishddgr.fish"
    zsh_completion.install "auto-completionzsh_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "q:Homebrew", shell_output("#{bin}ddgr --debug --noprompt Homebrew 2>&1")
  end
end