class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.9.tar.gz"
  sha256 "c07d6c8b4942e9a112d04c60a3ed45d29bd4dbb4cb136bcb80b1e631079877b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303cb1a8b019283396e3153172117e1f11dcd8c73dab227a8f2c03f8301e1034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35f02b4888e9b2919d68a5e368826abb4cb0e1313caf0d9fc290722059701b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "485ed9ce3d6db3a3c14ddd92165a02139632d3aa0caab917f461279ce1c326b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc4e3374c411f56ec79ea92d7b50e79487ff2cd541ceefe87b8ae287c8325d2a"
    sha256 cellar: :any_skip_relocation, ventura:       "b3805dd01d7c17bb642d2f6ac63541ebc54ab00a8c43ed93d13e99a4452a9cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b274fd18236f763b8e6e166d812d4cb7725f9fac2361e2d93b68af5807f7f617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b6eeb872b9598d528409c61a894fca86b76947de480be8ee2c366f2a74b4fc"
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