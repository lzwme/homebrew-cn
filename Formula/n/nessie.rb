class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.5.tar.gz"
  sha256 "6f430bc1530e63ee107b3dac3006eaf19dc8b7e4241e697a8ded2db04469a182"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21aec2f752a8c3a0e8bf8d9753365cc4893c4a9358aca886d18ad771895d1e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d8821a8d9e49cf998a28caed317a5b5e6eec78e072fb8ae4f9bce7b9b4f7eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69d53624827e38e2dc656930aa81b018d6709fdb241ee675821f8f995962678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c58dd1cde3bd766f7e09a82de9165ebf5b4ea560ab6fde398bbd3ad887a999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d6c4094f20265a7e8faa6984ae37e663e9d298a37a5f911e535ac41bafafbe"
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