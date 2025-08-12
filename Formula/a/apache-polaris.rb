class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://ghfast.top/https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.0.0-incubating.tar.gz"
  sha256 "4ed1a13aae04c8bf25982bc059e12d3490cb70ddf3b175dc97a227b46a566e10"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(/href=.*?apache-polaris-(\d+(?:\.\d+)+)-incubating\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651193a8f10b0c26dab239210f54945b941bcc8b32ff36ca4a711a25ea171c28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1723a5e2227e1fc846448527ed63bf01fbd2d54408e63430b39bbd2f6f2aea98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98d67992486f8b8dd409325f6573f5b27757fc21326b02e1237fbdcd3b481570"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ee0608dd98311e960c8948f7fe4c8157ea6b3d21e5ee49381241263a31f858"
    sha256 cellar: :any_skip_relocation, ventura:       "7383dcf9f868196365a1f529829cbffc19f11e5d1ede1d345658d6e8be615bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592619c84b43b42ca83191cfc5da00981d6a0fbe5cc2a7858df1eb5d64b8b20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5fc3d56012a19e29fc5a6e4439f5c5661649d1e2a8192fefd62542dd7c25bfa"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "assemble"

    mkdir "build" do
      system "tar", "xzf", "../runtime/distribution/build/distributions/polaris-bin-#{version}-incubating.tgz", "--strip-components", "1"
      libexec.install "admin", "bin", "server"
    end

    java_env = Language::Java.overridable_java_home_env
    %w[admin server].each do |script|
      (bin/"polaris-#{script}").write_env_script libexec/"bin"/script, java_env
    end
  end

  service do
    run [opt_bin/"polaris-server"]
    keep_alive true
    error_log_path var/"log/polaris.log"
    log_path var/"log/polaris.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"polaris-server"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end