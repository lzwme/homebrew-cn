class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://ghfast.top/https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3950stable.tar.gz"
  version "3.95.0"
  sha256 "b718abbaae648b902534c47c80da3b908b1588c743507701be37cf97f533828c"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00331b4a9927b93ee3115ef914b345e2d4e00d9ca7969051a38e520371f6de2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8efbe46bbf1020e43b663768aa3b015119b8a816c5888a99b6177403f1f54eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b07ccd5e48a5370a1e7cf3dddd04f056f302e8d183a24dd745889a5c488aac06"
    sha256 cellar: :any_skip_relocation, sonoma:        "91285bc40e41a994fe54b223448f693d49bd80b78027023fa0023c759e5ce94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f80704a8a8861b52871488634258bb3d323d6a49b90c17dabf9c220581a44d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54524c5f7a895a56d1e8cb9354594d4766833600b0fa90819a3681b267d11f0c"
  end

  depends_on "gnu-prolog"

  def install
    system "./scripts/install.sh", "-p", prefix

    # Resolve relative symlinks for env script
    bin.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      f.unlink
      ln_s realpath, f
    end
    bin.env_script_all_files libexec/"bin", LOGTALKHOME: HOMEBREW_PREFIX/"share/logtalk",
                                            LOGTALKUSER: "${LOGTALKUSER:-$HOME/logtalk}"
  end

  def caveats
    <<~EOS
      Logtalk has been configured with the following environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}/share/logtalk
        LOGTALKUSER=$HOME/logtalk
    EOS
  end

  test do
    output = pipe_output("#{bin}/gplgt 2>&1", "logtalk_load(hello_world(loader)).")
    assert_match "Hello World!", output
    refute_match "LOGTALKUSER should be defined first", output
  end
end