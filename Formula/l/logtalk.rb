class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3900stable.tar.gz"
  version "3.90.0"
  sha256 "bfad817d96ca3fd5208a833d1672390d75bf40fef3a00b473469811306f4e20b"
  license "Apache-2.0"
  head "https:github.comLogtalkDotOrglogtalk3.git", branch: "master"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b80d4e2e6e0de2891a89e7a2e5e157385cf647520954c25e4765bd46fbbc0e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f41d19e22a51c183821dc1da5f3bc396a651a33644a202fb24debc34ce2ff7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ba5df685d9665e28d0662b86f41c0ff0ac62b8334ec0ffea1d4bb7585b9e75a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c696e94d4cac544b4c0b0356e04b564d4e50cedc03f429f5f36c67d61e874f9"
    sha256 cellar: :any_skip_relocation, ventura:       "1b653e0be56af8746d3f440a2e74e2768f050e37b73b1efe7ba7bfd0651c62c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6413bf5295dbdb564f546201ed52badad96792d11f4086e6ffee2f54d6ce8eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad43f409a9787f73a056e901209308012a7fe9f364af969060e322039b043851"
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