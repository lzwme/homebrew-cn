class Mailcatcher < Formula
  desc "Catches mail and serves it through a dream"
  homepage "https:mailcatcher.me"
  url "https:github.comsj26mailcatcherarchiverefstagsv0.10.0.tar.gz"
  sha256 "4cd027e22878342d6a002402306d42ada1f34045cc1d7f35b5a7fa37b944326e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b2e53d4fee8a25e01abeaa5e827e4fa0713c4ec4bcadaaad95db6f53b2b5139e"
    sha256 cellar: :any,                 arm64_sonoma:   "b1e3e8c79312f8a9cfc995ebf3323750c1673da1bcc46129a516124575dd4116"
    sha256 cellar: :any,                 arm64_ventura:  "48ba775de03b394c5c7981e4e990094c1e7d98781af790f0658d8596f6126250"
    sha256 cellar: :any,                 arm64_monterey: "72fd292521f629a91abc5a99d386689e263553cee6fe70be5ed87f1feec8a3cd"
    sha256 cellar: :any,                 sonoma:         "c9df904bb52b0d9d3f0e4ef939d2b213fc9de876ade935ac59a215962754ee10"
    sha256 cellar: :any,                 ventura:        "989284e497267b0c55b25e7102650703d7938d4f0ac985c1cf44f62deb930bab"
    sha256 cellar: :any,                 monterey:       "30f848d4cbd189a75d7870b2ac8a78b6f411076c82530e24e1930d5c16819b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70607653632478ba936cb62f56377dc9e17670f453e4018ea39694a15cd2837"
  end

  depends_on "pkg-config" => :build
  depends_on "libedit"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "ruby"

  uses_from_macos "xz" => :build
  uses_from_macos "curl" => :test
  uses_from_macos "expect" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "libffi"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "node" => :build
  end

  resource "rack" do
    url "https:rubygems.orgdownloadsrack-2.2.9.gem"
    sha256 "fd6301a97a1c1e955e68f85c861fcb1cde6145a32c532e1ea321a72ff8cc4042"
  end

  resource "eventmachine" do
    url "https:rubygems.orgdownloadseventmachine-1.2.7.gem"
    sha256 "994016e42aa041477ba9cff45cbe50de2047f25dd418eba003e84f0d16560972"
  end

  resource "daemons" do
    url "https:rubygems.orgdownloadsdaemons-1.4.1.gem"
    sha256 "8fc76d76faec669feb5e455d72f35bd4c46dc6735e28c420afb822fac1fa9a1d"
  end

  resource "thin" do
    url "https:rubygems.orgdownloadsthin-1.8.2.gem"
    sha256 "1c55251aba5bee7cf6936ea18b048f4d3c74ef810aa5e6906cf6edff0df6e121"
  end

  # needed for sqlite
  resource "mini_portile2" do
    url "https:rubygems.orgdownloadsmini_portile2-2.8.5.gem"
    sha256 "7a37db8ae758086c3c3ac3a59c036704d331e965d5e106635e4a42d6e66089ce"
  end

  resource "sqlite" do
    url "https:rubygems.orgdownloadssqlite3-1.7.3.gem"
    sha256 "fa77f63c709548f46d4e9b6bb45cda52aa3881aa12cc85991132758e8968701c"
  end

  resource "tilt" do
    url "https:rubygems.orgdownloadstilt-2.3.0.gem"
    sha256 "82dd903d61213c63679d28e404ee8e10d1b0fdf5270f1ad0898ec314cc3e745c"
  end

  resource "base64" do
    url "https:rubygems.orgdownloadsbase64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "rack-protection" do
    url "https:rubygems.orgdownloadsrack-protection-3.2.0.gem"
    sha256 "3c74ba7fc59066453d61af9bcba5b6fe7a9b3dab6f445418d3b391d5ea8efbff"
  end

  resource "ruby2_keywords" do
    url "https:rubygems.orgdownloadsruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "mustermann" do
    url "https:rubygems.orgdownloadsmustermann-3.0.0.gem"
    sha256 "6d3569aa3c3b2f048c60626f48d9b2d561cc8d2ef269296943b03da181c08b67"
  end

  resource "sinatra" do
    url "https:rubygems.orgdownloadssinatra-3.2.0.gem"
    sha256 "6e727f4d034e87067d9aab37f328021d7c16722ffd293ef07b6e968915109807"
  end

  resource "timeout" do
    url "https:rubygems.orgdownloadstimeout-0.4.1.gem"
    sha256 "6f1f4edd4bca28cffa59501733a94215407c6960bd2107331f0280d4abdebb9a"
  end

  resource "net-protocol" do
    url "https:rubygems.orgdownloadsnet-protocol-0.2.2.gem"
    sha256 "aa73e0cba6a125369de9837b8d8ef82a61849360eba0521900e2c3713aa162a8"
  end

  resource "net-smtp" do
    url "https:rubygems.orgdownloadsnet-smtp-0.4.0.1.gem"
    sha256 "098d28fab9d9bc280a2cfada77692cdca89c83c6789bdbb8d8429f97f1bf5a33"
  end

  resource "net-pop" do
    url "https:rubygems.orgdownloadsnet-pop-0.1.2.gem"
    sha256 "848b4e982013c15b2f0382792268763b748cce91c9e91e36b0f27ed26420dff3"
  end

  resource "date" do
    url "https:rubygems.orgdownloadsdate-3.3.4.gem"
    sha256 "971f2cb66b945bcbea4ddd9c7908c9400b31a71bc316833cb42fa584b59d3291"
  end

  resource "net-imap" do
    url "https:rubygems.orgdownloadsnet-imap-0.4.9.1.gem"
    sha256 "2f869dc18e3f4a61e5f4c68d6e33e2db5b6d661dfa9151b2b20aa7dfdd342e7d"
  end

  resource "mini_mime" do
    url "https:rubygems.orgdownloadsmini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "mail" do
    url "https:rubygems.orgdownloadsmail-2.8.1.gem"
    sha256 "ec3b9fadcf2b3755c78785cb17bc9a0ca9ee9857108a64b6f5cfc9c0b5bfc9ad"
  end

  resource "websocket-extensions" do
    url "https:rubygems.orgdownloadswebsocket-extensions-0.1.5.gem"
    sha256 "1c6ba63092cda343eb53fc657110c71c754c56484aad42578495227d717a8241"
  end

  resource "websocket-driver" do
    url "https:rubygems.orgdownloadswebsocket-driver-0.7.6.gem"
    sha256 "f69400be7bc197879726ad8e6f5869a61823147372fd8928836a53c2c741d0db"
  end

  resource "faye-websocket" do
    url "https:rubygems.orgdownloadsfaye-websocket-0.11.3.gem"
    sha256 "109187161939c57032d2bba9e5c45621251d73f806bb608d2d4c3ab2cabeb307"
  end

  def install
    if OS.mac? && MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec"bin"name, libexec"bincatchmail"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove temporary logs that reference Homebrew shims.
    # TODO: See if we can handle this better:
    #       https:github.comsparklemotionsqlite3-rubydiscussions394
    rm_r(libexec"gemssqlite3-#{resource("sqlite").version}extsqlite3tmp")
  end

  service do
    run [opt_bin"mailcatcher", "-f"]
    log_path var"logmailcatcher.log"
    error_log_path var"logmailcatcher.log"
    keep_alive true
  end

  test do
    smtp_port = free_port
    http_port = free_port
    system bin"mailcatcher", "--smtp-port", smtp_port.to_s, "--http-port", http_port.to_s
    (testpath"mailcatcher.exp").write <<~EOS
      #! usrbinenv expect

      set timeout 1
      spawn nc -c localhost #{smtp_port}

      expect {
        "220 *" { send -- "HELO example.org\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "MAIL FROM:<bob@example.org>\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "RCPT TO:<alice@example.com>\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "DATA\n" }
        timeout { exit 1 }
      }

      expect {
        "354 *" {
          send -- "From: Bob Example <bob@example.org>\n"
          send -- "To: Alice Example <alice@example.com>\n"
          send -- "Date: Tue, 15 Jan 2008 16:02:43 -0500\n"
          send -- "Subject: Test message\n"
          send -- "\n"
          send -- "Hello Alice.\n"
          send -- ".\n"
        }
        timeout { exit 1 }
      }


      expect {
        "250 *" {
          send -- "QUIT\n"
        }
        timeout { exit 1 }
      }

      expect {
        "221 *" { }
        eof { exit }
      }
    EOS

    system "expect", "-f", "mailcatcher.exp"
    assert_match "bob@example.org", shell_output("curl --silent http:localhost:#{http_port}messages")
    assert_equal "Hello Alice.", shell_output("curl --silent http:localhost:#{http_port}messages1.plain").strip
    system "curl", "--silent", "-X", "DELETE", "http:localhost:#{http_port}"
  end
end