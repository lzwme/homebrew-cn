class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3901stable.tar.gz"
  version "3.90.1"
  sha256 "cbaa3d98c85d2b8fdc4b2c926a519f62777edb8eefdfd13e9c38c8d84ba536ce"
  license "Apache-2.0"
  head "https:github.comLogtalkDotOrglogtalk3.git", branch: "master"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d7afc3012ec621aef40acdad671e4b58b9de0db492747f02905492a3c1f6e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00918b6068e9a80124715a0f846c578d0f37570cccadafb28332a95232ae0c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84ca617dba0f45e9df2efcb75b97f5980a0fe7b4494a92cd608043bfbcf152ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "35c732226469e67fc990eb4f11185db41bed9b8c13b9f682719aa859ddd05bee"
    sha256 cellar: :any_skip_relocation, ventura:       "89e773b8dae00a0bdbc28c014615f15a75f64ed072c250019d3d40db0633fec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59cb51c1a1725a4c3b510b3193145eedfb29c96dcc24c17c3561041352460636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390329d20ebc07db91fd10fcccc0653d3422191c0d9e2ebd5266f330fd20ef5b"
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