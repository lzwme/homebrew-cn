class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
  sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b2d908e4e43ec3f0f63dc6e9ff7572403cfbe27a3a068b356c71aae76b23c08c"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  test do
    (testpath/"README.txt").write <<~EOS
      .. include:: docs/header0.txt

      =========================
      README: Docutils
      =========================

      :Author: David Goodger
      :Contact: goodger@python.org
      :Date: $Date: 2023-05-09 20:32:19 +0200 (Di, 09. Mai 2023) $
      :Web site: https://docutils.sourceforge.io/
      :Copyright: This document has been placed in the public domain.

      .. contents::
    EOS

    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man", testpath/"README.txt"
  end
end