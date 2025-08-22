class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.5.tar.gz"
  sha256 "5455fba07389763bb570461919813a797fecde0015f491ff7b9f4a4e0fc13c67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f969c199a08768d476514d7b0dd3991e3e804e3619e52b507dc799efbfe393c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b43c48bccea2c450b5c1b791ef18415a55b8ddb1844591227b4825264be814d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b09972ef9c5e4a68283acc4999340286c8bf4b41350de59ff352220fe5fb076"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c7feb33e2b121ac33e06ca507581f47991a1ba7a12020ff2e1ba426c122e49"
    sha256 cellar: :any_skip_relocation, ventura:       "1b8132fab0a55e3db3b5b52499c651d2a5b77005db4267c87a6a33bd0b4ab861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "234df679bb23212d007831488d168a251dbffd16c5bdd9079ca5725a575d1cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d52bc5ea57e7abfea630dd733e9c760f335f61a0ef47db6945f8df7e745950"
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