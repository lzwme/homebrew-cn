class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3890stable.tar.gz"
  version "3.89.0"
  sha256 "78174128b65713c1ba33b8c3249cafd9fcc36d175bd077946cdb928693505e2b"
  license "Apache-2.0"
  head "https:github.comLogtalkDotOrglogtalk3.git", branch: "master"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "282159ae479f934271a7ce10cb245d030e436f98e54bd7c86b32646f9cf07c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ba61e29d620300eb4264b17fa0c1e234107ef0460f971288b4a914c50bb564"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23df59e2602c5306bcfb2b95b259fb3cb9d107c61a4b4c77e4aa8b3be49d56b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96b2319cc3a807c9d4ab78db2066fb02e9320b4f3214dc7cbbcd0be63de2aa7"
    sha256 cellar: :any_skip_relocation, ventura:       "b57ec5b770e678d0e220f905855691dac1d15f11a25623d73af144764225fd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a89e5adf20b7efdea3e4a10eca4d6414d5e8b8a6f48645c0605ae3c7ddfea5"
  end

  depends_on "gnu-prolog"

  def install
    system ".scriptsinstall.sh", "-p", prefix

    # Resolve relative symlinks for env script
    bin.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      f.unlink
      ln_s realpath, f
    end
    bin.env_script_all_files libexec"bin", LOGTALKHOME: HOMEBREW_PREFIX"sharelogtalk",
                                            LOGTALKUSER: "${LOGTALKUSER:-$HOMElogtalk}"
  end

  def caveats
    <<~EOS
      Logtalk has been configured with the following environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}sharelogtalk
        LOGTALKUSER=$HOMElogtalk
    EOS
  end

  test do
    output = pipe_output("#{bin}gplgt 2>&1", "logtalk_load(hello_world(loader)).")
    assert_match "Hello World!", output
    refute_match "LOGTALKUSER should be defined first", output
  end
end