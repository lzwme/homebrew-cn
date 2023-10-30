class Riemann < Formula
  desc "Event stream processor"
  homepage "https://riemann.io/"
  url "https://ghproxy.com/https://github.com/riemann/riemann/releases/download/0.3.9/riemann-0.3.9.tar.bz2"
  sha256 "c3752ff91307870d7f1b4c24ca07cb6dacde8a766aadbc552f83459b2d7f4604"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "213c1a7bfea909691de7725c9d4f1ca671352b0f753cecbc5230318539144f6c"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/riemann", "$top/etc", etc
    etc.install "etc/riemann.config" => "riemann.config.guide"

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    (bin/"riemann").write_env_script libexec/"bin/riemann", Language::Java.overridable_java_home_env
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
    run [opt_bin/"riemann", etc/"riemann.config"]
    keep_alive true
    log_path var/"log/riemann.log"
    error_log_path var/"log/riemann.log"
  end

  test do
    system "#{bin}/riemann", "-help", "0"
  end
end