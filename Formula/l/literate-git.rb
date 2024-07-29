class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https:github.combennorthliterate-git"
  # TODO: migrate to `libgit2` after https:github.combennorthliterate-gitissues11
  url "https:files.pythonhosted.orgpackages7febb9798ba7c4e818b26b7214dff2bd43d4ec58c8dab956e5d71e9b5549b099literategit-0.4.8.tar.gz"
  sha256 "4dbbaf08a6db02d8a1076e3ef54ea046bd297b47abadd06c35812a4ca2aff8a1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1722d6de47dcc48b4b8a8ccb761322e77db27ba1beb8f296c20fdcbe7dba2f9c"
    sha256 cellar: :any,                 arm64_ventura:  "8e8a91a76d187d0296c05f5e5adabe92420dc3716d2b9fcb4f9137cec806b68a"
    sha256 cellar: :any,                 arm64_monterey: "64c7dfbc25daf870feb1985800a848c0eb159602c16da39a3659863d2b67dcfa"
    sha256 cellar: :any,                 sonoma:         "6f4892b45f55314d8df0ff6315f7cb9ca646dfe312a0b010e1b571f1c2201dd3"
    sha256 cellar: :any,                 ventura:        "ba4895c0f38a653533b55987831c316447806ac3a384870ee607879d3f4fd57c"
    sha256 cellar: :any,                 monterey:       "38e490a8c38bd6c7dec3a10cb6dd597642b70ef415a7d98c540c1fcc3fecc91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12c28303e4b8278ebd3be782886a94b57afca2873df274a8a4402c4acb56bd8"
  end

  depends_on "libgit2@1.7"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackagesda003c708de5bffa0494daf894d2e8e2b6165f866ef3ae7939546fae039b5f0emarkdown2-2.5.0.tar.gz"
    sha256 "9bff02911f8b617b61eb269c4c1a5f9b2087d7ff051604f66a61b63cab30adc2"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackagesf05e6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bfpygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages32c05b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931setuptools-71.1.0.tar.gz"
    sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end