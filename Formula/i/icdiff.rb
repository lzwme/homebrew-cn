class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https:github.comjeffkaufmanicdiff"
  url "https:github.comjeffkaufmanicdiffarchiverefstagsrelease-2.0.7.tar.gz"
  sha256 "147ebdd0c2b8019d0702bbbb1349d77442a4f05530cba39276b58b005ca08c77"
  license "PSF-2.0"
  head "https:github.comjeffkaufmanicdiff.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6ba3e02ad073e679bbb3b44e9fde5fd9f6d14bef29fff42918438fa6d88fd6c2"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "icdiff"
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath"file1").write "test1"
    (testpath"file2").write "test1"
    system "#{bin}icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}git-icdiff"
  end
end