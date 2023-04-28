class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/f1/45/f22cf6d9e569fc89267a79142a724cc92ccc002e0a61b1fff6833e70b866/dtrx-8.5.1.tar.gz"
  sha256 "93391ee16d752ed043756bc5c9a9f12a7a73c1ce2a5b2288c52ff3b61f7f5032"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c713499fdbc61e419be44dbdd0666528a86c71ad1391601903bfba4f6e25ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "116cc345259aa1259fa55332e8e4fc7f92ddd15784bc0714cbe8be5a19df8a77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9be0297da4adb68b6932820c6689451a2182bcebfc68c471ca2c45df1e5ca02"
    sha256 cellar: :any_skip_relocation, ventura:        "8da7d5224e42c3a694cf26f2ffda4daa112192ecdb8bf1fb790ff2606008e09f"
    sha256 cellar: :any_skip_relocation, monterey:       "d25fe203713960aa25bdc1a6c2f69b212f10319113f73802b082472cf6e47154"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c2521c71630734069eba5fa16187aed88e01bbf01966a81fc8cc027dd7ea205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56bce4bb0603902c60931742a535c8a182c8e330dd76725c0eac2bb3e02e1d06"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end