class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https:deployer.org"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comdeployphpdeployerreleasesdownloadv7.5.6deployer.phar"
  sha256 "ee741006edc46a97d522c41b84cdcdcec0da5807afcd0e7d6e737d0970b723aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0525fd0dd685a00f848dacc06b9608c7ce0a1aa3d4b1633295d9de1b28a6ebbd"
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