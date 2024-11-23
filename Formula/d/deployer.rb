class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https:deployer.org"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comdeployphpdeployerreleasesdownloadv7.5.5deployer.phar"
  sha256 "30c1c09038b0c390f40d21b3cb0a9e1ff46cfeefe4da1c834aeca6adfb5952d4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e54fce47176409d67d6508aa9b661e62600d211fe8ad81948029823f7a51b32"
  end

  depends_on "php@8.3"

  def install
    libexec.install "deployer.phar" => "dep"

    (bin"dep").write <<~EOS
      #!#{Formula["php@8.3"].opt_bin}php
      <?php require '#{libexec}dep';
    EOS
  end

  test do
    system bin"dep", "init", "--no-interaction"
    assert_predicate testpath"deploy.php", :exist?
  end
end