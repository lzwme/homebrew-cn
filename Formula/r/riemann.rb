class Riemann < Formula
  desc "Event stream processor"
  homepage "https:riemann.io"
  url "https:github.comriemannriemannreleasesdownload0.3.12riemann-0.3.12.tar.bz2"
  sha256 "82c24c7cba3bce96957f25661f39c6162a262ba76aef24e986e73dbf2a79b7a6"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23e04604313424736f08c1643acb79a66e80665193f341f18e3b4221037b1c7e"
  end

  depends_on "openjdk"

  def install
    inreplace "binriemann", "$topetc", etc
    etc.install "etcriemann.config" => "riemann.config.guide"

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    (bin"riemann").write_env_script libexec"binriemann", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You may also wish to install these Ruby gems:
        riemann-client
        riemann-tools
        riemann-dash
    EOS
  end

  service do
    run [opt_bin"riemann", etc"riemann.config"]
    keep_alive true
    log_path var"logriemann.log"
    error_log_path var"logriemann.log"
  end

  test do
    system bin"riemann", "-help", "0"
  end
end