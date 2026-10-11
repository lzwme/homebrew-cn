class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/fd/6c/f2b084289e0079df6992e3890658c29841be956601d557ccd559fe3fcc58/linecast-2.10.1.tar.gz"
  sha256 "21deedc30ce83c8ba344a05c4c83c5bb5c67a7d6a6c7cc4bedf9966c6902d82c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c64fd2dd132ea5fe33b1a39a4a2207f8afe74017e6d2719dc38675e817d17b7"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end