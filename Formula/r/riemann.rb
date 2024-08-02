class Riemann < Formula
  desc "Event stream processor"
  homepage "https:riemann.io"
  url "https:github.comriemannriemannreleasesdownload0.3.11riemann-0.3.11.tar.bz2"
  sha256 "074f5004e5511f1c0f47ba0165abab5cc825c79711fe837b78429586cdd95327"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f65525b430428ed10383deb50c93d9091d78c07c265872aff4216986541d6331"
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