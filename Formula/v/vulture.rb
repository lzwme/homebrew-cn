class Vulture < Formula
  desc "Find dead Python code"
  homepage "https:github.comjendrikseippvulture"
  url "https:files.pythonhosted.orgpackagesba1ad4154700ed512e5274ef923b4281e5a33a3da107a6c609e0e5c68be9355cvulture-2.10.tar.gz"
  sha256 "2a5c3160bffba77595b6e6dfcc412016bd2a09cd4b66cdf7fbba913684899f6f"
  license "MIT"
  head "https:github.comjendrikseippvulture.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57548c07281d6a72181fb78a517c195c2d161f0271a3ebc324cdeaf05ad84d47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ddc26d8cf34f2e7a583d499e6f2d286264368b61fefd85562a8095075774993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a88c345c6eee7b6b1beb9ee0829bd024c230ec1110635ab6b0f77ac5e03ebe"
    sha256 cellar: :any_skip_relocation, sonoma:         "cff0b61afcfc1ae4e603e90af72eaec4be6b372c689d29d60e7be8b1d6b119d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f4a20f92ef6a7beeb67cd334f602f6e1bbadc39fa2311a47b451a1372c8ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "8bc1940bc824e36e1073fc400ce907033fa86c1f42e0d41b698ccbc5bc81be21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1caebf07d12f4042d49a478b253545bbce8935b7e07fdbb47761c37ce8c161ed"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-toml"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}vulture --version")

    (testpath"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}vulture #{testpath}unused.py", 3)
    (testpath"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}vulture #{testpath}used.py")
  end
end