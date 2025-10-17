class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.5.tar.gz"
  sha256 "b7213b06979e16e12811f5d57c3cbdedeb8442df87143d4193c148076352e4d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bbcc7d0c6ba9649a6daa03db17f005d801748c856d9e626200689877c15f468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4ca38414a01fd65d35918d99da53f6568a31dc3bf82741d3e2d0bfadfb04fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "654bfd78e84d71c3507dd8ee5f375f5e41ca541eca6b59ddeca5d3501d9f4ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0e286e0042669ca69299218cb60900b4d45560db7ffc4f570567a243f68deb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa93b49d080430974993e01ac05b0735f82745807ed9c8c093845c604223134a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b907f94f3b40465fd870c89bd8ffa209f8ebc713798222233e623669619f03ea"
  end

  depends_on "gradle@8" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end