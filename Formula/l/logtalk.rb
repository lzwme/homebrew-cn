class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://ghfast.top/https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3970stable.tar.gz"
  version "3.97.0"
  sha256 "2850a6f9e0d9e017bfe535d02d89b8389af7fbfa9dda9f1b521b197bf2a4b968"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8872b350b8c719edc608e2441086415ec84097bb387cb4fe4238498bb72e94a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa514d37e701d40bff4089d0d9b5f603781c6672b0db19a069c06272f5c4116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57bee9a9a2e67a1cde9ac726e788a143d80bb1851a5f314bf68aaf9f5088f042"
    sha256 cellar: :any_skip_relocation, sonoma:        "89781686f260b0b19cddc4066047c6aee12e6bcd29e6b5aff5c34af21babf4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccab904a4c4cca3d5eabea269619a74e3d6507e185d1fca121bbe62f43882a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7dba471929dfa79b78eae968ebee186d62ef6f136c69074d45928fdd797aee8"
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