class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https:www.znapzend.org"
  url "https:github.comoetikerznapzendreleasesdownloadv0.23.1znapzend-0.23.1.tar.gz"
  sha256 "9576460eb25b57bc7e5ecae9d0d425cbf5a27eb945cea9b6469d33bcbb331803"
  license "GPL-3.0-or-later"
  head "https:github.comoetikerznapzend.git", branch: "master"

  # The `stable` URL uses a download from the GitHub release, so the release
  # needs to exist before the formula can be version bumped. It's more
  # appropriate to check the GitHub releases instead of tags in this context.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c08a027832f431c8377d2efea5d97145c693013fccdc4515295932f3abe819e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33fddef0ea178c4033d09613156d6964f1e702f2cc0689fe3775f7a3337eddf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a659521cff92d607ab62fb6c55516ecaf3153802bbf02fa5459326abfbaab4b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "07b4eb4ba18e0293883b53a9bef027ce6035187d1b4f9862ca4c6f184810cd40"
    sha256 cellar: :any_skip_relocation, ventura:        "8d0e17ffee85b044cf4ede6a638dcfaf2e454ed1e774021d74e2dd9032a1eaf7"
    sha256 cellar: :any_skip_relocation, monterey:       "e494c129c407e8875750c6bade567cfb2091335bd40d00d84f80ca5b2443b0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b73958ae0f2d978241211d7d7aeefba66474e2c9e2951c496a92b422d595373"
  end

  uses_from_macos "perl", since: :big_sur

  def install
    system ".configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var"logznapzend").mkpath
    (var"runznapzend").mkpath
  end

  service do
    run [opt_bin"znapzend", "--connectTimeout=120", "--logto=#{var}logznapzendznapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    require_root true
    error_log_path var"logznapzend.err.log"
    log_path var"logznapzend.out.log"
    working_dir var"runznapzend"
  end

  test do
    fake_zfs = testpath"zfs"
    fake_zfs.write <<~EOS
      #!binsh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}znapzendzetup", "list"
    assert_equal <<~EOS, (testpath"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end