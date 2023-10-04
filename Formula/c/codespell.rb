class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/e1/97/df3e00b4d795c96233e35d269c211131c5572503d2270afb6fed7d859cc2/codespell-2.2.6.tar.gz"
  sha256 "a8c65d8eb3faa03deabab6b3bbe798bea72e1799c7e9e955d57eca4096abcff9"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c16233869623f279d39c9868d2679501cea1bdf1bd5ecdd3541255c89489b46e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84525740e3a2496e47627d113cc6d8a1084d6abbe4d79374db6e23d48ef0536f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b83abe4d2e6dede87848fdb28951d2369ef6c57238c2c958bda30f7b77610e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "87cc81986615b16b7853579c879948c742be38b954799b040af2605163b73239"
    sha256 cellar: :any_skip_relocation, ventura:        "5dd81567618e1274aa7f4f71a06f0e1b210af89bc6152331051b05c517ef42ed"
    sha256 cellar: :any_skip_relocation, monterey:       "5af272bbde1aac9a1630ccf8dc99e561fd76703e446d759be01aff458fa7c5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a6952f0ffb74d2e30463eedd8977834aca933dae65e82042aceee453483bbe"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end