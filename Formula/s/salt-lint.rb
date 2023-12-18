class SaltLint < Formula
  desc "Check for best practices in SaltStack"
  homepage "https:github.comwarpnetsalt-lint"
  url "https:files.pythonhosted.orgpackagese5e94df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5csalt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d2cdc09e20b05ef45c8ea7525a357450ebdf867e3813f62cd18ce07f85b720d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a10c7a245f037a496a25389c10f66d86e92b822ee582f50fe9f27890f5609aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e09050c5903ca1b96df6c3d2ce065f1db084f719582648af9daba3afa8c80e4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "71c604bf31211c265da05e71f0a42966bb014e303042012a959683c71edc9eaa"
    sha256 cellar: :any_skip_relocation, ventura:        "42effd243df6229f09bec381d5b1173961f7405df5de9381fe85035561a5aae7"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf071bdf7391d71463ae6dc94f99535ee1c63c5fb5ffd7785102b20bc7809cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c078eb6a20855ba5acd4eab424ce00a363abafe2f257f0b9fc8e270ca9b0fa3"
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
    (testpath"test.sls").write <<~EOS
      tmptestfile:
        file.managed:
            - source: salt:{{unspaced_var}}example
    EOS
    out = shell_output("#{bin}salt-lint #{testpath}test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end