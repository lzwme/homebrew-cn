class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/0b/06/fc42ca93a1eea8f881e904fd6d9137bd31ce7407afae603aa478f9c0c235/docutils-0.21.tar.gz"
  sha256 "5d8f180bd488c582c7738061c99e8001bf02765827a0d98ccd5e813f11769fd5"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, sonoma:         "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, ventura:        "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, monterey:       "09c0234bff094ff3cdf3f0080f0fa536e3856f333437c2f3833d912358f3ec33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644296dd3ea5be965ad4e2d904517181fd6d513aab4063ae3e58046b38aa9fd7"
  end

  depends_on "python@3.12"

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