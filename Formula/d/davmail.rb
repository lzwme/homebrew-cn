class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/6.2.0/davmail-6.2.0-3464.zip"
  sha256 "15ab41d2dfc185944ca1f604d0a0f92c36068c343c86b888b332893fca8dbe1c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/davmail/rss?path=/davmail"
    regex(%r{url=.*?/davmail[._-]v?(\d+(?:[.-]\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80da03fb83172d20a4adefbf8e56a6a9d37ebdc0cdbf6dfc8e71cc9f67d614d9"
  end

  depends_on "openjdk"

  uses_from_macos "netcat" => :test

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"davmail.jar", "davmail", "-Djava.awt.headless=true"
  end

  service do
    run opt_bin/"davmail"
    run_type :interval
    interval 300
    keep_alive false
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    caldav_port = free_port
    imap_port = free_port
    ldap_port = free_port
    pop_port = free_port
    smtp_port = free_port

    (testpath/"davmail.properties").write <<~EOS
      davmail.server=true
      davmail.mode=auto
      davmail.url=https://example.com

      davmail.caldavPort=#{caldav_port}
      davmail.imapPort=#{imap_port}
      davmail.ldapPort=#{ldap_port}
      davmail.popPort=#{pop_port}
      davmail.smtpPort=#{smtp_port}
    EOS

    fork do
      exec bin/"davmail", testpath/"davmail.properties"
    end

    sleep 10

    system "nc", "-z", "localhost", caldav_port
    system "nc", "-z", "localhost", imap_port
    system "nc", "-z", "localhost", ldap_port
    system "nc", "-z", "localhost", pop_port
    system "nc", "-z", "localhost", smtp_port
  end
end