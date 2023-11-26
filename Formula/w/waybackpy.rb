class Waybackpy < Formula
  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fdaf90f9d5ca953d6ebc090de108e99bfbb9759899253d6cd6bb76eeba344b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a12a497824de92c1ba5287bbf98af3d4bc5fcce0a232a8d5d426a968845803cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196ad9b18ccf207f92c99e83669a901bd29193dfa1add821976c622ee16d6352"
    sha256 cellar: :any_skip_relocation, sonoma:         "52febffbb2185bfbbee265b7d55b49f1acf9362b549f981553794389ff53a9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "229d1d542b9a15760919aad962fcec2229bfc7ef2cf6c1ca6124abad89305e19"
    sha256 cellar: :any_skip_relocation, monterey:       "b35f8d283ffd5a775d85879c752eb8f4a842c783f30d9ce5f0f0b928127d343c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0284b868c2a7956f9b3ba6e551fea911b1c92ce57a38823fce9574a846409d8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end