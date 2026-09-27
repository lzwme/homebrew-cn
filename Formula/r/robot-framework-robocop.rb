class RobotFrameworkRobocop < Formula
  include Language::Python::Virtualenv

  desc "Static code analysis tool (linter) and code formatter for Robot Framework"
  homepage "https://robocop.dev"
  url "https://files.pythonhosted.org/packages/21/a6/3dee138281a211bb44cff4f3e88a48a1a0e0b782f1746a46b2da1970fa87/robotframework_robocop-9.1.0.tar.gz"
  sha256 "1204a8645a48eaba0a7779035a8af3419a681fa3d511b875f57856e5357fe749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b2412a399ab2e1a79c083d83ae40a83f9c5b2c6fee39bee6b1beb82db96e32a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d746b9d2cf820ad07b8816a318e96eb68071d23b70d7fe70efbc121cc4c1ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ba782c253ec44bc7abae7a944eb96889a5c5bf80ca7a8d6e856cb9d2c3c666b"
    sha256 cellar: :any,                 arm64_linux:       "9a32d972ad37653d440fc43dd3b34a7f4305a5b05a3f45d3e805b45a0cf22005"
    sha256 cellar: :any,                 x86_64_linux:      "4b69ce7e8bd16218e655f9a9f04cf121f31589024dd1cfbaed06352ef220aa9a"
  end

  depends_on "python@3.14"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/6d/44/ea2100ec54d30c46ee9dba10a3bfb79b655e96c6df237238a3234c75869b/msgpack-1.2.2.tar.gz"
    sha256 "9eb0b0e602064527a045ea28c4f174ed69383587e29cebe28947e3b84106eb2a"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/53/0e/7be2983c52622d6c0899300f760e31ba143355cedf1afcb3e65689d5ca85/platformdirs-4.11.13.tar.gz"
    sha256 "6985eefdc2298693e4ce1fe124645524cb967428eb6384e0ce5b49767e7ea8ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "robotframework" do
    url "https://files.pythonhosted.org/packages/66/77/5f60e5619082d387971d111c1354f1f529d2959ee742877982002d38d53d/robotframework-7.5.tar.gz"
    sha256 "ff6233ff752a200ece4d0a6c59f6f9f7d0e96dcff0a7a3458296b997b812482e"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources

    # The `robocop-mcp` server needs the optional `mcp` extra, which is not installed.
    (bin/"robocop-mcp").unlink

    generate_completions_from_executable(bin/"robocop", shell_parameter_format: :typer)
  end

  test do
    (testpath/"brew.robot").write <<~EOT
      *** Test Cases ***
      Homebrew Test
          [Documentation]  Test case in Homebrew formula
          Log  Hello from Homebrew!
    EOT
    assert_match "Missing documentation in suite",
      shell_output("#{bin}/robocop check #{testpath}/brew.robot", 1)
    assert_match "1 file would be reformatted",
      shell_output("#{bin}/robocop format --check #{testpath}/brew.robot", 1)
  end
end