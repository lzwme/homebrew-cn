class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.1.tar.gz"
  sha256 "12b8462bf74682ea12992ec5c5ff94696d452834ef620e4bd101637f17fbee5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f7b7ab084c1caca8419b69a5d0b98c4166da4ab1439bc7c76024e786733fd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71fb70a4f530222631f7336bed4e073aab4a928e7cd549c32cd285274716716b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f305fe63e5a81eecb8b2c01b3363b8de82ee4527e539100be04eba38e8e117"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd1c5319043875a4f259576a3092c08036c544cdfa062fa4552be3bcee827e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0d974d7fa435ae8e569462491f411b02a74963a248e62d88f8d87d416c1582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743aae126d028c75abe02ee86f61be8c2a1d501994c0354c7fbb180e1030c36e"
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