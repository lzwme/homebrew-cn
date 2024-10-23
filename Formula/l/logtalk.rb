class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3840stable.tar.gz"
  version "3.84.0"
  sha256 "5a1d52accd4730097f8a0b89570ac849e8a6325afe853b0fbd1f30aa972e2d2c"
  license "Apache-2.0"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f7ca5f9c30029b535b925c5e68e196a25004280bf079dd298c49a35bd86ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16addd4874037e6be5694900130c5f6844afd85f998c86648be892a49b79f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54ad323dd1678beb399160f3ac5f7fcf15bc7e793b3a9ac1365ca4dd83420fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "40c344604bbe578506b97f29a498194a2ca1542740afee2de4f8d304baabff22"
    sha256 cellar: :any_skip_relocation, ventura:       "53c02f11e3de46e09f80aaffcb68f382f759600c985bcb47ce1c421f06e78c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726714a27c65c07e0817b2e2103310298ad16e817eb2a4d4f86347bd7a10093b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system ".install.sh", "-p", prefix }
  end
end