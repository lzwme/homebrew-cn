class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https:github.comasottileall-repos"
  url "https:files.pythonhosted.orgpackagesa65629006be2546b897a5c62a3d4a7e613abf5a3533554d948b0e0af27546f1ball_repos-1.27.0.tar.gz"
  sha256 "96fea3e34caa004b0770501e6efb93dc49cbca05fb56c2b8b2a85d06fb3a4573"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b6ec8dae833a83273149d93e816172afe534422110b32b1930d4e413675e9c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1955bdb52812a676344316e6036712d3b2635b30b15c2a6c9553c9f075494e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97faf13030d107338dcefbf7f802427ef5f1875cea3172b7eee3c27e319a1a31"
    sha256 cellar: :any_skip_relocation, sonoma:         "e24fa2e9011f27177b5afbb3f1a0e25f629c1e62fec41094ce452cb1d75b1251"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca812e7833dec7e82f0b6be3e5961bec7f29bd42d644ac15d02a51ff16843be"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ad7a62acebf34ff28b05a770b418ea22f2e174f84f8f8ffef41917ba4f11f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf83b12937c8d65cd17b606b443d08e8878cd08f25a96975b55c5f83e3a9314a"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "identify" do
    url "https:files.pythonhosted.orgpackages61a092aba7e128faadab9db785c1f8cc442caf51cba5a55b575abb211b12526fidentify-2.5.33.tar.gz"
    sha256 "161558f9fe4559e1557e1bff323e8631f6a0e4837f7497767c1782832f16b62d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath"repos.json").write <<~EOS
      {"discussions": "https:github.comHomebrewdiscussions"}
    EOS

    system bin"all-repos-clone"
    assert_predicate testpath"outdiscussions", :exist?
    output = shell_output("#{bin}all-repos-grep discussions")
    assert_match "outdiscussions:README.md", output
  end
end