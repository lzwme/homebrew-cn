class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1f/4e/343d044d61e80a44163d15ad2f6ca20eca0cb4fef4058caf8e5e55fc3dd9/virtualfish-2.5.9.tar.gz"
  sha256 "9beada15b00c5b38c700ed8dfd76fe35ad0c716dec391536cc322ddd1bccf5e2"
  license "MIT"
  revision 4
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ec7d315ffa74e0af9509d52ac82f4407b2722f578c058ac60d76dfa5b93890c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b589647c6d7eccb9ff5b6ad8322cde12d4179cc3a0547d1a9ea6684d6b8df7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4ea35f7009bdec568fa19c64f799247cadf99f9d47a4753cfc4fccaea42c1ec"
    sha256 cellar: :any,                 arm64_linux:       "9d2c2c173f6474c6d1f6f1814c46c451dffaf660c33eb4c04f92f8c929444b8d"
    sha256 cellar: :any,                 x86_64_linux:      "19ea5b4c379cff7ddb882aded55c0c99cd3aaf2d8beeb9df99d2d8bf922f1087"
  end

  depends_on "fish"
  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/51/2bc9e529f154fad99b6cd0073e609291eb32fd23581b32362d33d164d316/filelock-4.0.9.tar.gz"
    sha256 "635e7d67fa92654eed444e75e9ca18426d34e77ad9c469bf4373f75a932f7b22"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/52/fd/0adde075cd3bfecd557bc7d757e00e231d34d8a6edb4c8d1642759254c21/pkgconfig-1.6.0.tar.gz"
    sha256 "4a5a6631ce937fafac457104a40d558785a658bbdca5c49b6295bc3fd651907f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c4/f9/f323b3b6058cff3853b31cf6a49c0425ed797bf9611572ec10d065e08bac/virtualenv-21.14.5.tar.gz"
    sha256 "c4cb6c13e46b57225a999c7e22a09b163393878facc7ac4c059a57f46faa1647"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath/".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}/vf install'")
    assert_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath/".config/fish/functions/fish_prompt.fish").write <<~FISH
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    FISH

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # cannot delete virtualenv on sequoia, upstream bug report, https://github.com/justinmayer/virtualfish/issues/250
    return if OS.mac? && MacOS.version >= :sequoia

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end