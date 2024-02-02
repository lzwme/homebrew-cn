class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https:github.comsnakemakesnakefmt"
  url "https:files.pythonhosted.orgpackages1fced2dee5da2cf76cdec5a5fb9dc7b99849b08ea28a5dc17830afc2baadaffcsnakefmt-0.10.0.tar.gz"
  sha256 "53eae69fc81425e2192684eba76171bd648b05dcba93c9d5f45746d3fadb8617"
  license "MIT"
  head "https:github.comsnakemakesnakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c380f23bcefe6ae493c5e80fa63d11d4f8c91eabdc8f7193c2a5f9048956355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb73ba8b36c759effa2e4b2ef7c4fb6aab7c36cfc813cd342ed7397ace3c8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd85b4174fcaae8451eec7a2b8a53df6d42fe086c389bc87f3c0ec652e1aaa42"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0a3a5feccf5a0fb29ff4335cc31372961f4e8401baad5c0f45fd8d3adbadd81"
    sha256 cellar: :any_skip_relocation, ventura:        "de5275204de7ef868613ff572e8963227a8c75997a801fd297b5a6ceacca14c2"
    sha256 cellar: :any_skip_relocation, monterey:       "f373cd795202fea97e9218333948d2b2ccf74bac3ef267afe0d20c4bde801b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bddcb117afcf59fe1d937b5e63ad31af703779787a1c03f5514f277b7bcef36"
  end

  depends_on "black"
  depends_on "python-toml"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    black = Formula["black"].opt_libexec
    (libexecsite_packages"homebrew-black.pth").write blacksite_packages
  end

  test do
    test_file = testpath"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}snakefmt --version")
  end
end