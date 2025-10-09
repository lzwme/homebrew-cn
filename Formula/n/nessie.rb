class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.4.tar.gz"
  sha256 "c55f62b580ce7f78c20d8dafbd03541a78a052477756fda032e2ea19341adfb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84bce255a4dd7a1b9699c4529f4c101aad64ab46e038bace8193efadf056089c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a99c643012cb3f080b82a1796f3f94be8ffbaf023d33a6c3fb40f76ded278a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1154a80be1bdf946d543097408cc4647c88c130e1a26b7c12d1084805d670c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3929082ae5daee37f336f38816af1ba82d83ef391e44243a069ecaf77149fb13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f2d0165fc7c25ee16f49d9998e6ba71394ebe29cf0cbfbd692ebdced81a680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b504c7deca06c4b21ed1234103ceef293a5ac9554f1cc78ca82aec5c2752534"
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