class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.6.tar.gz"
  sha256 "b7c8333ca1f58f3506b2d44f885d9c20ede525a655f97ec496f9861437f853f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8ee96cfdf7fdfa76cb84879bfc5350e8d0d8b576e75e89b6883d5ed275f011e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc8e1aabb9ecb95693683cb8fb12118a45d795b6f5f237737db2ee265a0056c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9984c58890a436b394978fe8496ba1b6c30e1cc1bab95d2dd4a92cb51f73df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4ec166af613f82ae7e1e4c42d87fdbbb62ee8a3cef11a31fd34ced27a83345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb88d39ec9efba67387ec9e879214e73311f2919b17ed7bedfa995192fdc9a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9bc9731d97ccc06a9334553b4b49d5aaa553c7bdbf6d29bf3418fd14c63528"
  end

  depends_on "gradle" => :build
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