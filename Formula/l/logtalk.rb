class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3860stable.tar.gz"
  version "3.86.0"
  sha256 "e148b618e29e02c5b089947fe17b0d33ed0f7811503f02aae0615034059c2dd3"
  license "Apache-2.0"
  head "https:github.comLogtalkDotOrglogtalk3.git", branch: "master"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d2ff8e80dc5c78c149080683999669d9d03bad57dc9c82a3c473e5b21a22ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e1211196484a7076cc58d99ccd9d2f1dc806bf9a54104b9aebb31774de1325"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35bb980b6d1b5a7f3fc3209109ca77d641cbbd04e0c69bd3530c2e3b0335f2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bc207677ff22b8199965bb3121fef82fbf2bd3cabe6be28091bef8044e4850c"
    sha256 cellar: :any_skip_relocation, ventura:       "d77f21958798328b662fba2f945a357c771cc9816e225216ae82530f868c57f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16824737bb87f86f034d047ebba947148e7c44d43a5e72e69efb77191ffca477"
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