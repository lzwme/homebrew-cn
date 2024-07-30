class Lorem < Formula
  include Language::Python::Shebang

  desc "Python generator for the console"
  homepage "https:github.comper9000lorem"
  url "https:github.comper9000loremarchiverefstagsv0.8.0.tar.gz"
  sha256 "3eec439d616a044e61a6733730b1fc009972466f869dae358991f95abd57e8b3"
  license "GPL-3.0-or-later"
  head "https:github.comper9000lorem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79e38b6949ebd14157f0177fae6331e780f1889c76594c86dea7d649ef5c9057"
  end

  uses_from_macos "python"

  def install
    bin.install "lorem"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin"lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}lorem -n 2").strip.downcase
  end
end