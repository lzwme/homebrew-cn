class RobotFrameworkRobocop < Formula
  include Language::Python::Virtualenv

  desc "Static code analysis tool (linter) and code formatter for Robot Framework"
  homepage "https://robocop.dev"
  url "https://files.pythonhosted.org/packages/24/90/248070b2def441f19f8f936024c62ebbdb90c1a610f5b5470f0ea1118d9c/robotframework_robocop-9.1.2.tar.gz"
  sha256 "ce93c6a46434bd5e2a40f6fec81514cb9fe1c9ee4fa97db03d1d3bed541688b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8666ece8b90fd189f08936709500db60ea6f5c5b537d6fd7ffa4316f1f486d4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04474ba3a27ffc0749f1de410c1e9262674f1a964b076747523bdc3a899223dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d19ddc0173a48a7ee550d2b3ee4dfc055cb7ff5c693aed936750a0aa6ec6a86f"
    sha256 cellar: :any,                 arm64_linux:       "377139662a57debc3d644b2f98ce4d5571d58803bc91ffd852f9d4b2026204b6"
    sha256 cellar: :any,                 x86_64_linux:      "9ae9bf414dd92c91d484c587c0be4bec1a5455ce71b29c2ee10a0514c902cbdf"
  end

  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/0a/e7/bb605a7bab2d8425a64b3fa762b39dc1bf1c7e3f11ba6fb5413d6db0ff8c/msgpack-1.2.3.tar.gz"
    sha256 "32edb81a2b5eb7cd7c9d941b2bfbbb082fd2cd09e0e725930316af6b708db186"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
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
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
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