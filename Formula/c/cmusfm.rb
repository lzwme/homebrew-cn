class Cmusfm < Formula
  desc "Last.fm standalone scrobbler for the cmus music player"
  homepage "https://github.com/Arkq/cmusfm"
  url "https://ghproxy.com/https://github.com/Arkq/cmusfm/archive/v0.5.0.tar.gz"
  sha256 "17aae8fc805e79b367053ad170854edceee5f4c51a9880200d193db9862d8363"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb2e0a7092079e3ad015e27ea37ff940d6ef9a6fed73ff2355d6d7b23d04c0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7580167d4bd0c71cdafc4dff2ede95d0081dab49e0f0b555fffa1e29eba03381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25de6ec5f582426deea7f1bae8f97e9adf9074f598d2a1a28c14c5d5ecc64602"
    sha256 cellar: :any_skip_relocation, ventura:        "f1346608b765ed2219f6b963d80b8b72a90b430a10894fe924d64d2d67c535a4"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e90bb7f3dbb25e7149d8e6c47a54725095b5dca2ecbdd2ad91d0d383824a28"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef7f13482b03d75ce2eb9c4ce72123f997f68c246477445b9aeb1d4e0d49e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85080d3911b11f136d5baf6e3304d50c7bc8918aee103308068cd817162e993f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libfaketime" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "autoreconf", "--install"
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
      system "make", "install"
    end
  end

  test do
    cmus_home = testpath/".config/cmus"
    cmusfm_conf = cmus_home/"cmusfm.conf"
    cmusfm_sock = cmus_home/"cmusfm.socket"
    cmusfm_cache = cmus_home/"cmusfm.cache"
    faketime_conf = testpath/".faketimerc"

    test_artist = "Test Artist"
    test_title = "Test Title"
    test_duration = 260
    status_args = %W[
      artist #{test_artist}
      title #{test_title}
      duration #{test_duration}
    ]

    mkpath cmus_home
    touch cmusfm_conf

    begin
      server = fork do
        faketime_conf.write "+0"
        if OS.mac?
          ENV["DYLD_INSERT_LIBRARIES"] = Formula["libfaketime"].lib/"faketime"/"libfaketime.1.dylib"
          ENV["DYLD_FORCE_FLAT_NAMESPACE"] = "1"
        else
          ENV["LD_PRELOAD"] = Formula["libfaketime"].lib/"faketime"/"libfaketime.so.1"
        end
        ENV["FAKETIME_NO_CACHE"] = "1"
        exec bin/"cmusfm", "server"
      end
      loop do
        sleep 0.5
        assert_equal nil, Process.wait(server, Process::WNOHANG)
        break if cmusfm_sock.exist?
      end

      system bin/"cmusfm", "status", "playing", *status_args
      sleep 5
      faketime_conf.atomic_write "+#{test_duration}"
      system bin/"cmusfm", "status", "stopped", *status_args
    ensure
      Process.kill :TERM, server
      Process.wait server
    end

    assert_predicate cmusfm_cache, :exist?
    strings = shell_output "strings #{cmusfm_cache}"
    assert_match(/^#{test_artist}$/, strings)
    assert_match(/^#{test_title}$/, strings)
  end
end