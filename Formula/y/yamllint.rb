class Yamllint < Formula
  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/fd/98/ec541c8dff395b9e441d46ab678c9a0f00f5ca479f070a6ced3b425cce79/yamllint-1.33.0.tar.gz"
  sha256 "2dceab9ef2d99518a2fcf4ffc964d44250ac4459be1ba3ca315118e4a1a81f7d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9620b829fbf98a7654d999de4ca8b03cec9449b06a9666fe51df0f1d2a5c24e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c02c3420ccc0cfbda0e0fb860d387dee3571e45e0f765414e72a68cc7af7eabd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5751e0a610ca6f2e70d9e44a2acbb2af5cc5f023990a2f8fddfd14ba91d5fed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb72bf9791b3dc9f1c8e04530d71a56542fd8fade5b21c28d79b6b1dffc56ee7"
    sha256 cellar: :any_skip_relocation, ventura:        "3b93aae189674bb20b0e8a3cff2e55d1cd54e077e6e827493b3d791df10e0c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf55a5d187b656fb4f7809f19bf1b5e8c3afdd64b0aa779a6a34d5db4caa53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0973a341664899738f453926ad4eb6013be85dc40f8cdbefa6b95650525ab2f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-pathspec"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end