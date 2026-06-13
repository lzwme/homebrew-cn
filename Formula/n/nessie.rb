class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.0.tar.gz"
  sha256 "6b1ad60b6497188d7651288cd394638f483f4f7f848e68c55f18b1d7f3ea3772"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad6e81b280999265d8e5bd354cfa32de413310224e3c5a7214eaad6c6850c54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0817c59c889fc4b9ba59decf75338993e179157f626c6e76bc40de21d84ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac506d3d86fd18fad8eebdc3e8f87e40fe62e0c9b4b7c80a964b9e46f4ee8956"
    sha256 cellar: :any_skip_relocation, sonoma:        "85397286214b13de5668c69c68ad2b4b9e40e44e18b0d450d5938f1c33822d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade5954a63dcd622e33cf4f7bfdb56c2fbf8c4ce95da2fc374a76889ce70eeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c662578a47526a1429befad1dc907c153d8f2d7270a01a1088614d8c580ae30"
  end

  depends_on "gradle" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie", java_version: "21"
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