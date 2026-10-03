class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/be/65/4cef8ae8f6dbcb5753b202e46791277f1ea0b4a0650d1a6cb940c468b143/nox-2026.8.17.tar.gz"
  sha256 "8d9c69c9b996a59db1eb2c6968deaebc2edbc55317d205981bbc4a37351d3f2e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0947fa33fac238bb3b8842451485a0c91fc04e618d2173ff6a68c345bd4d0aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0947fa33fac238bb3b8842451485a0c91fc04e618d2173ff6a68c345bd4d0aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0947fa33fac238bb3b8842451485a0c91fc04e618d2173ff6a68c345bd4d0aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a655d8cf99f75c29b53163137680bb13d8e7a366855270fada7c2b826a536b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a655d8cf99f75c29b53163137680bb13d8e7a366855270fada7c2b826a536b7c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
  end

  resource "dependency-groups" do
    url "https://files.pythonhosted.org/packages/b5/16/65e61d8e837e0d70a99a0d4dd76e2af53357c3a03ed1db8ad9b5786d7f25/dependency_groups-1.3.2.tar.gz"
    sha256 "c81831f43828dbc3987ee247eb198241a0152b8e7ceab10977cc3808eb388ac7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/cc/19/d4f21fc4b7ad098dd3c774ccb2a2929178b15d6e1a3ba7d0929817c0b30c/filelock-4.0.8.tar.gz"
    sha256 "733d9b6b153fc63672f86104324186818b6bbe9dd7db84e9bb9887b6a04a2775"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/67/57/630a01cf5ab58f33b9c7dc8a7f13464cb5740b5227f8a08cab9d798bd532/virtualenv-21.14.2.tar.gz"
    sha256 "571930928b11e43db690073ad8228162eca8a3f8fd3a87acdeae07df7dd57068"
  end

  def install
    venv = virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "nox",
                                         shell_parameter_format: :arg)

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~PYTHON
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    PYTHON
    (testpath/"test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end