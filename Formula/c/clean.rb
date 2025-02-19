class Clean < Formula
  desc "Search for files matching a regex and delete them"
  homepage "https://clean.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2"
  sha256 "761f3a9e1ed50747b6a62a8113fa362a7cc74d359ac6e8e30ba6b30d59115320"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a1e4fead81bdadea6bd617523d7628f215ae6ee6a440a761d9a8b93348471ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "399d484d9371d60bfebc828c350804935fef8f0657964aa5da9abe3e84fbbf65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8475c766c7581cc3723005a48d44c53f439740ebb004a213e813fe7fc9b110b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2545a16176fab56b543171ae6b9bb8bcc322b5db0098f5a080effc88835207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b10d60c05907f49e588abdd62e34d1f3ab34be1abb2dca155a82172ea366aa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1543a0abeb13df58fb46711b11431b7bb359c217f68bf29d70b5ddc780d86b7"
    sha256 cellar: :any_skip_relocation, ventura:        "eca64055ebc6c1f717ddc8d84d352dc9f1fd4f3d3d81dcdfd41b2e65c382364c"
    sha256 cellar: :any_skip_relocation, monterey:       "50f24835f266da1bb10c707e7f1561a3f9366b11bc6e61ac4919f806ddf7e182"
    sha256 cellar: :any_skip_relocation, big_sur:        "bca0f382d8835a36dd3ac9c4157f88f543291b21febea6c68769762f9067e2e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c4846ab5fe761673db9a5575b56ec21b4ae0d4d75a974015d946d25fde0def12"
    sha256 cellar: :any_skip_relocation, mojave:         "e715ac664f19bed88572c18765770713b8483bcf9fd0617e6739ada3fa8d68d7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d2f22ecaf65e902d6e0f878ec9585dd915f05d58121e95cfb5cff53d7905fad8"
    sha256 cellar: :any_skip_relocation, sierra:         "925b26f91800733aeda229bdaee74ecf4a70e1c94cb4e1b33ac3fc4f3948186d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7a433c07eb3c8a3846d352ddf27a6ac32fdc6528b6b2e6212f78318ff0f04a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f82459bafc17933f5010fe2f35355f8d967809ae62d1ac91e13409f7baec88"
  end

  def install
    system "make"
    bin.install "clean"
    man1.install "clean.1"
  end

  test do
    touch testpath/"backup1234"
    touch testpath/"backup1234.testing-rm"

    system bin/"clean", "-f", "-l", "-e", "*.testing-rm"
    assert_path_exists testpath/"backup1234"
    refute_path_exists testpath/"backup1234.testing-rm"
  end
end