class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.6.tar.gz"
  sha256 "ea0d050f4b219bbf496c87650eb37e55d42b0ed7d8d5e9fb99eb3d391fd7a883"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7701affa7494a738824a4d8da8a91dbfb5412c6ffb996c2903ea8f086a5014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abcca7862f7039c2a0ca57db9b376c47c0078e05398d28da62fdc0916a492d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18af26997d3ea69d8f070adfb40c0cc4d601f778f3b199ce8896e4ca620dc1b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf83ce990fd948ecec155e8d517e99b7ad4ed280057e29104b7bc6f1aa5027c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873aa053c4eae7a9eeb999df7ba7f9e16d9fc61ed3b720d0711a132d0a03e8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11854dd6a99945025316ed4ec275c2aac9b59274a65a495d96f1195519a0a535"
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