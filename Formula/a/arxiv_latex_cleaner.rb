class ArxivLatexCleaner < Formula
  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ba/75/626014f47d51aad0e6ef39a051ba7fe24a4e4f8b0bf23750909615d62864/arxiv_latex_cleaner-1.0.1.tar.gz"
  sha256 "d9fae07f82f8ad19704ff58fe4e1ed7fc668cc28ea6238c13bf5d687c988d79c"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a432863ab41703801ef90ab1895a866f065570f895230e7588b61e9e26833a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d32c09ccbfda6e83f7160d0db1063948cdc8fd0e72f92a0c9271e284f99b0c75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6130fd9978b322dbf181a3eeb371742f685e2738a3ad5873ec755868c5f8e47"
    sha256 cellar: :any_skip_relocation, sonoma:         "831ae869581b5545d0d5d952274f2b45b72701991e31793999d1a4a1da2d24a4"
    sha256 cellar: :any_skip_relocation, ventura:        "2339b9c7c4ca1706147eb12dc4a63ec58291cee0e2abd4e109d39cc464e8a4b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b899b4b517c390f0f192441e0dc138f4588dd878702820b52a1578a4cb92de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6369444304a56f816fbc7d50e403bbddacfcaa37e87249f083b3f11e9898f9eb"
  end

  depends_on "python-setuptools" => :build
  depends_on "pillow"
  depends_on "python-abseil"
  depends_on "python-regex"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end