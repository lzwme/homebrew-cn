class Bashate < Formula
  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef03c3fa96db7cfbf69ebeba21301c3760bb7f14dc46d9b74588bfac756ec01b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff66343cf32860271f667598d87696fe72d6e65900dfdcf6115abea14d613eed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b353b15aba538b3c8d4590f7b801d89c4ad5db691a485a841f0ea436221c1fe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fc245bac330eab2cefc2dd3212ed58a061f6a5500d578abec4f8a3db4a2721d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3d887b439b7c2e487a4dd8b75fe15424c30d65963c1629343ba745d1ccdbcf"
    sha256 cellar: :any_skip_relocation, monterey:       "5dde169aec8a9ed21dff77b70a83f282620805110eebb0a7f56c4a9bf4cfb208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d760da6d91318d5f9e1ee0a0bdb716145bf0c9bf50531350796df64a583d1721"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-pbr"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
        echo "Testing Bashate"
    EOS
    assert_match "E003 Indent not multiple of 4", shell_output(bin/"bashate #{testpath}/test.sh", 1)
    assert_empty shell_output(bin/"bashate -i E003 #{testpath}/test.sh")

    assert_match version.to_s, shell_output(bin/"bashate --version")
  end
end