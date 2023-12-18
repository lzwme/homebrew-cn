class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https:pgbadger.darold.net"
  url "https:github.comdaroldpgbadgerarchiverefstagsv12.3.tar.gz"
  sha256 "c3d5a583d12b09f7b47e628760ccb7409362c54b5ca574de4cfd3ccf51c35106"
  license "PostgreSQL"
  head "https:github.comdaroldpgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2547486d3f93f5286b8dfec62e5c9e76d581ed1f288ee26aac17c03c0c6b3ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1cd6c1b0711912d768b8cc087c77d58a073e409e7b5b79f84435e0255c7420d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1cd6c1b0711912d768b8cc087c77d58a073e409e7b5b79f84435e0255c7420d"
    sha256 cellar: :any_skip_relocation, sonoma:         "76cc989760a49002fa77717a297e4b1e96f481c006b51e8d224b6fa7b78bff9d"
    sha256 cellar: :any_skip_relocation, ventura:        "3f2ab67a09f1dfc5dff12714af123e89f4271b925fd25dc21030adbc4f09cd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "3f2ab67a09f1dfc5dff12714af123e89f4271b925fd25dc21030adbc4f09cd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72da09ce68c0d4a5d631a4e4ece1c85edc86072dc5c06f003094d4484eb90a4a"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    man_dir = if OS.mac?
      "sharemanman1"
    else
      "manman1"
    end
    bin.install "usrlocalbinpgbadger"
    man1.install "usrlocal#{man_dir}pgbadger.1p"
  end

  def caveats
    <<~EOS
      You must configure your PostgreSQL server before using pgBadger.
      Edit postgresql.conf (in #{var}postgres if you use Homebrew's
      PostgreSQL), set the following parameters, and restart PostgreSQL:

        log_destination = 'stderr'
        log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
        log_statement = 'none'
        log_duration = off
        log_min_duration_statement = 0
        log_checkpoints = on
        log_connections = on
        log_disconnections = on
        log_lock_waits = on
        log_temp_files = 0
        lc_messages = 'C'
    EOS
  end

  test do
    (testpath"server.log").write <<~EOS
      LOG:  autovacuum launcher started
      LOG:  database system is ready to accept connections
    EOS
    system bin"pgbadger", "-f", "syslog", "server.log"
    assert_predicate testpath"out.html", :exist?
  end
end