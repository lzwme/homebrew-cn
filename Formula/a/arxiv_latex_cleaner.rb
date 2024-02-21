class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https:github.comgoogle-researcharxiv-latex-cleaner"
  url "https:files.pythonhosted.orgpackages66878866fcffec4c6d39eaa7a08e3bb0b98ec98464aef55fcf0897196819a2f0arxiv_latex_cleaner-1.0.4.tar.gz"
  sha256 "6c371dd6c7bec01259bebc80820e6704274d2f5f75f9de1d112d9d3f8a392023"
  license "Apache-2.0"
  revision 1
  head "https:github.comgoogle-researcharxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cd192afc47b746c94d9044671eaddf63aa263c0a658c37a4b8cd5636dcf5d74"
    sha256 cellar: :any,                 arm64_ventura:  "db4f54fb4d80516c6c76eccb843f17fb143f6bcde9a4c60c151cbce9a1096e15"
    sha256 cellar: :any,                 arm64_monterey: "e36c22728bde52b262d0814f5f57a78b0fe30e718bf5f0aca467f1eed328ccd2"
    sha256 cellar: :any,                 sonoma:         "25458ce654e5845f4b747368277d1d3e80b95acecb1d862191b07fad7a75b087"
    sha256 cellar: :any,                 ventura:        "d0d6cac23647b60d7dcaaf443d7965664bf10550b7f83da834b608a49d857ab6"
    sha256 cellar: :any,                 monterey:       "6fc2033be2ea22ecd4e465f48bac1cb89595fcc2de572edf5010a79260207aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9730a7fe31d8f209af51b670a903c65a501b34c336c52546b46de3f120d7ba84"
  end

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "absl-py" do
    url "https:files.pythonhosted.orgpackages7a8ffc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06eabsl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath"latex"
    latexdir.mkpath
    (latexdir"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin"arxiv_latex_cleaner", latexdir
    assert_predicate testpath"latex_arXiv", :exist?
    assert_equal "keep", (testpath"latex_arXivtest.tex").read.strip
  end
end