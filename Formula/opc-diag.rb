class OpcDiag < Formula
  include Language::Python::Virtualenv

  desc "Tool for exploring and diagnosing problems with MS OOXML (.docx, .pptx, .xlsx)"
  homepage "https:github.compython-openxmlopc-diag"
  url "https:github.compython-openxmlopc-diagarchivedevelop.tar.gz"
  version "1.0.0-python3"
  sha256 "dd93ecaea30b22298d228e6d2431be8027d43d7543e15877cf5deeb1135a51e0"
  license "MIT"

  depends_on "python"
  depends_on "python-lxml"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}opc", "-h"
  end
end