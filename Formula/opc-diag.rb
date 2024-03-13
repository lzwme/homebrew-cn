class OpcDiag < Formula
  include Language::Python::Virtualenv

  desc "Tool for exploring and diagnosing problems with MS OOXML (.docx, .pptx, .xlsx)"
  homepage "https:github.compython-openxmlopc-diag"
  url "https:github.compython-openxmlopc-diagarchive7ed49f0c0be161218e7d015554d61755e497a5ba.tar.gz"
  version "1.0.0-python3"
  sha256 "90fa3f0fdef1ef7c26d2ba15521b49a0c6a3e0322f508edd74db4fb1a0276cd2"
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