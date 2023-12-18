class Riemann < Formula
  desc "Event stream processor"
  homepage "https:riemann.io"
  url "https:github.comriemannriemannreleasesdownload0.3.10riemann-0.3.10.tar.bz2"
  sha256 "76421dc7ef51ab7a5a0c61cabb03ba46cad0d6eda6bd19e7704c8e207a8e0513"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd28525585ae3a108adcff28cf6f04806733411341894dda25714f3fc1d58588"
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
    system "#{bin}riemann", "-help", "0"
  end
end