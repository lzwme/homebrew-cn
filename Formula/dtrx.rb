class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/61/23/138d9a64c60ff077b9ca11bd36c6f153f662183cda457d667c73e4cad9ea/dtrx-8.5.2.tar.gz"
  sha256 "e7be0d4659be7c5c589dcdb27930b8ec116110cb31530f796594eea3217703fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "893cfcf3c97e13a89d47514527bd52219360243383647f4e8f476416c50435d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241f422938a7014875633100039983c3403f9db9155c0bcc2a899609288f52e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f13dc029894fc38d98ee6d71ce9a838dd9be3a0ba64e1b2766cccb630ef4272"
    sha256 cellar: :any_skip_relocation, ventura:        "917c141f925a50795b6b7f9df4d02056c1bcdd51bbae8cd03cc1db94267d277f"
    sha256 cellar: :any_skip_relocation, monterey:       "738824eb1dbcfd302b5f37ad5d45ec0bec43cc00bc41f25c6ec014ff22f98199"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3175a5c4e7d1bfaac4845a83a427a3b1355aa10389bf9bd5210939b8c5a2e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e966c3b25c2ecdbddcec854a43ed93763aa7aee40f4181de6bc541572193e190"
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