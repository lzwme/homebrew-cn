class Pipdeptree < Formula
  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackages6aad108aa2c69632c929d83d2f23a9621b08649a284540829d228bc394d6b0f1pipdeptree-2.13.2.tar.gz"
  sha256 "1237791977ef61602dc967b287167c1a6b058501afbc145a04e835c622355e6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18c060dcdf02adc9421bfd7fb3ed12030c8bb315f2b6f9a7dfb442633b95b759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf5fc40397ec9cadd7b64fc9e7e7493816ec70173af56705728856c7a0fc03d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c0aa2ec350e8acb51ad44ce0af1dd604d43016dea92dc789f74b9ea4b75c3f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b12470082c181dd80de1842839ff023dfe50de089e04987f15eb5e12d8ebd71"
    sha256 cellar: :any_skip_relocation, ventura:        "e0214165bb730b8c740bb360d12495acc9fc512d1712d7bc4fa7d2b88c40ce64"
    sha256 cellar: :any_skip_relocation, monterey:       "ff85fd9a5673d890b1645047332ca7bcfb8bf8f7e6476415c3bfc7546ba6c444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfc512f19cfa63370dfeacd87f76b01634b93dedfa08c7e798791cd59b288f5"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end