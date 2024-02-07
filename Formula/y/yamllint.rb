class Yamllint < Formula
  desc "Linter for YAML files"
  homepage "https:github.comadrienvergeyamllint"
  url "https:files.pythonhosted.orgpackages911c9e9c7be901a58c82ab437e3e36f0dd0f5ed76687b1ddff9a9519d7c5875dyamllint-1.34.0.tar.gz"
  sha256 "7f0a6a41e8aab3904878da4ae34b6248b6bc74634e0d3a90f0fb2d7e723a3d4f"
  license "GPL-3.0-or-later"
  head "https:github.comadrienvergeyamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2c7af04cad22bf7774b178d359194640840e0120b085f1ff9357dbfeb869c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3fa38fc60cb71ac91560aea632134c104520e0f01a06abbd20364211ae1a989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "accbbf0eb1134eeceb373cc9bb09052c3a1f28806aa89de212b95ab5c24e6ea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6caee252f7d4768297704a7378f517d53608352aef512fa6da8b0dddd43d20a6"
    sha256 cellar: :any_skip_relocation, ventura:        "dbbe3c4287f505126715bbf5f36dc98b22d6a6136724fc95f9154fa1578c877a"
    sha256 cellar: :any_skip_relocation, monterey:       "6416777b4fc9e8f1e1ebabc9284778918554ad8792f894b322d10ad57ca7acb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1fe6d3f1bf98b489c8d89000d0f69c091ee5d76c3ec46d09d375628368d1a00"
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
    (testpath"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}yamllint -f parsable -s good.yaml")
  end
end