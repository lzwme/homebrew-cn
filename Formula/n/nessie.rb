class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.10.tar.gz"
  sha256 "1fa5f7b0f2fccbbbf0776c3f53ef4c5eb0ecc656e204669882aabda6575aa2a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3b860092825f7ffaaa0d038f79aea3fdfe1752394b3a60fcfa51b69b5aea3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8db95949a7e8e7d24ad9b76c90817a998f4de41668e989ec0047dc5ad8b4d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12c79c75b0f9afec5bad4558de747163a22909d590b12caf81cf52f00f7bb6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd2d63404fc29d0715f01cad37856b822e4971731655ca2a245fe93d073baf0"
    sha256 cellar: :any_skip_relocation, ventura:       "f65b19cbcde827a7dde5941929243dae4ac666d944f20b5513c63952a0b27cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dbcf75d0045ffbbaa92d79441c5dab64a5a6344b8839f22eda62c45d7ede8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bfbec026201edac9c8b33d89fded939be5e428defcf88d4778a00f708c96df9"
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