class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3860stable.tar.gz"
  version "3.86.0"
  sha256 "e148b618e29e02c5b089947fe17b0d33ed0f7811503f02aae0615034059c2dd3"
  license "Apache-2.0"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04abffa7341ba7e3b7663c984658a138a9a411cb0b0b8bba73e8de8609e82ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b141ba8ed06324674b54b99413805e888c719c676d36ff09b31d68215fe29032"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f743668e3bd16c09a6c9caa6379471014db2929f066c1d4b50c05f0fe34a414"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ae44e4e63e0831043e4416345d0aa71a4f928280b794009382341fec0b6f4b"
    sha256 cellar: :any_skip_relocation, ventura:       "531a84404d20480ffd77f68baa6e703a9b31b228a2744932d7683d01cb9e9f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11546ac8f3869d260b182fc9ddc390a95bd08f515b6a6038e3e8462764927555"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system ".install.sh", "-p", prefix }
  end

  def caveats
    <<~EOS
      To complete the Logtalk installation, define the environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}sharelogtalk
        LOGTALKUSER=$HOMElogtalk
    EOS
  end
end