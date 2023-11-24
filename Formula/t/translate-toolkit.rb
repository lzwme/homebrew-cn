class TranslateToolkit < Formula
  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/2d/96/02265cf887313ca433d177ea4b1153826cf167c78a1456a5919c20eafd1c/translate-toolkit-3.11.1.tar.gz"
  sha256 "eb88f9874e622536774de9d40da3105d8aecdd2c114f18faadb3116e9d59c610"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc7d837a9c24d39411d0e56b08d94d5f414caa8bd7667410b6093855735674bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "861587d24dbfd114329d61cef12da40a3382a298426c5e8ffd173cedf11369af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff78aaa114090722323371882afee3df2bfc84de2006ba8b3a91eeb2f212bf38"
    sha256 cellar: :any_skip_relocation, sonoma:         "f365d521c7330476aeac03cbf08423393433cb4c4ee0b613b10de288405eae31"
    sha256 cellar: :any_skip_relocation, ventura:        "212847dccb7e729065c45f089cf8310eb2b52b6c65b89fc74b577bd0535a4fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "8125ed04b56ef797c61e5986545fbffba7423a69dcaee424dc4140898cee0dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0d04c381ff883fce706f01e11fd2f680f3567db26598b2f7c3f4e00a94cd92"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-lxml"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end