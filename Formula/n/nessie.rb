class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.3.tar.gz"
  sha256 "67ed6221ebceb3d55ed332e5461842bc3ca36273fd164d02d55498fce6af13ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c1bf0f8ef65fa160ae1c1c935de90c186c9b6664686fc9019f6397a4bf6b763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0c8340e59fc8816b27cd601ad369692e41d42a3a70aa26c87b560a42d66cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "622b2c514c1041795f53919c8b0e518f74cafaa98f1d8371449d1aad9343e557"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b523fc4c44cd2fd0e00523aaa76fb190dea1061cda44ddf81c4edde8fa0cef"
    sha256 cellar: :any_skip_relocation, ventura:       "2e3dd41f11bac0f494b2cf3714bfbf61d2f8fbfc8acdd8f709bec1c0a573a377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e5c9aa4c841234dbb71121fe7377499583faee57c68edd4e14202c47ecc28ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc8d5a1f0457913f58a48da28015d8447a66f113472ca85e39e1595a8175d23"
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