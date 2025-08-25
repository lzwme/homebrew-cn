class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://ghfast.top/https://github.com/librespot-org/librespot/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "61f90b661ba883890a7ed8fe3926372b99252abad11dcacf94f2c89df21b7746"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56d72b304c7af4c517ef7420d065940ecee98016ddb5622cf8092de869f5a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c42e31dfda749fa46a03a188fe36eb745fd4da81b140d37a2c68be150ed2efd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35b53bff4baa418d7cbdc96207afd6aa0287f107bcc578e293a4e4adf07acc7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1571710917e6db676739d93655d8969de847734a291744fcae0ace92b44d491"
    sha256 cellar: :any_skip_relocation, ventura:       "e0ad6323294aeb8b9ae38e72a2edf5a2fe47b6b676bdd09bbfb4d1c87c942b5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e1e10637fbcdc65a0f358ef4afd94f1c650b8dd303fe6b8cc507f29617df2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0765a0ce68b78e4ea45febd341b2a0742acad1cbfdc3cd095f03bfc3d6820a65"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features",
                               "--features", "rodio-backend,with-dns-sd,rustls-tls-native-roots",
                               *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, bin/"librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include?("Zeroconf server listening")
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end