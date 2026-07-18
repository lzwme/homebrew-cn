class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.2.tar.gz"
  sha256 "17507c914ab12f4261518f918e01e7babb7dcdd869428409c135d97c92678348"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c22d2faafba428eeaed88a6eebd19c884d593c00fbd2998e6ef766a53e4b1453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506930196821896f3aa9266ba0d79c13155c3469fd6b563a85a403494c19b38b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4a4f3eba5ab2ad8261d1b89f383edf0f5e673d5a5fb5df39b44ff2792a38b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "166ad0b0f1d7f2f03b0c4a0b042a5f17f0bed80500df501c243de3d55ce5721d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331da402b57f13aa63bc2fd7c6f2372d1a663dfed764cb297d6a60ddaf65a7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d4c911e6cb3c209090e9788f9e16526e3fba1778b9235000f8c5b14f6c15d0"
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