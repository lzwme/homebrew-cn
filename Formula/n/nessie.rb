class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.3.tar.gz"
  sha256 "f3cec51f89ab2bc9f10285bca759e2f817c574edaf8f176ca758cb73dffde95e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df5baeada48d94f2180a3ffda215aeb63cfd88a5f3f612a39a288ea1aa0133e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb4b6d8809d48516fdb945d88a208650203203369143b5eaf7f207d59e2d4333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf147a207cf2f89ab73e7905287e479ee897ca12cc294b7d8a1e15ca0809b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "98226c4584fb413fc8df080d69df94ec02d70860a2aaa9bb5d0b6311374da6f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a5c8e6ef32c2ac5e98103ebf19a7ab91a99528ecb949886b89c09c60c83cdf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9ed22e9e730cf79c9cbb57a238ad982cc0352b07f8cd662f7de4be53e28f65"
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