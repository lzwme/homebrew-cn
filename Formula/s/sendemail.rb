class Sendemail < Formula
  desc "Email program for sending SMTP mail"
  homepage "http:caspian.dotconf.netmenuSoftwareSendEmail"
  url "http:caspian.dotconf.netmenuSoftwareSendEmailsendEmail-v1.56.tar.gz"
  sha256 "6dd7ef60338e3a26a5e5246f45aa001054e8fc984e48202e4b0698e571451ac0"
  license "GPL-2.0-or-later"

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "113001c5e97ed667b4f8401c335b3a337a7354b1562ca8b40b6499e6cdb68278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113001c5e97ed667b4f8401c335b3a337a7354b1562ca8b40b6499e6cdb68278"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "113001c5e97ed667b4f8401c335b3a337a7354b1562ca8b40b6499e6cdb68278"
    sha256 cellar: :any_skip_relocation, sonoma:        "73385dfdd56d55f9236a3f3b438ca09ad283ef1f1e81b24e191b12bba3840ceb"
    sha256 cellar: :any_skip_relocation, ventura:       "73385dfdd56d55f9236a3f3b438ca09ad283ef1f1e81b24e191b12bba3840ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113001c5e97ed667b4f8401c335b3a337a7354b1562ca8b40b6499e6cdb68278"
  end

  # Reported upstream: https:web.archive.orgweb20191013154932caspian.dotconf.netmenuSoftwareSendEmail#comment-1119965648
  patch do
    url "https:raw.githubusercontent.commogaalsendemaile785a6d284884688322c9b39c0f64e20a43ea825debianpatchesfix_ssl_version.patch"
    sha256 "0b212ade1808ff51d2c6ded5dc33b571f951bd38c1348387546c0cdf6190c0c3"
  end

  def install
    bin.install "sendEmail"
  end

  test do
    assert_match "sendEmail-#{version}", shell_output("#{bin}sendEmail", 1).strip
  end
end