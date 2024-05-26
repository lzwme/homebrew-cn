class Zipkin < Formula
  desc "Collect and visualize traces written in Zipkin format"
  homepage "https://zipkin.io"
  url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/3.3.1/zipkin-server-3.3.1-exec.jar"
  sha256 "8012a5c5d0c6bcef12890ea513873f368df6c752c00cbc4f58f026904feafc7b"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2999674d42043fc04831ed3b4c1d8aaad0f0186e006750f41845e873de7d40f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a566abd4d1438ae4effb93fe3aaa526282aeb1239de8a3d537c7d5dfe39c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469bb59c07352321bedd5649e5dece59b4fab9fb00dde1d6cb219bdfb872d643"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a3743b91c94f913757bfb1ae6475b7f499a44b8ba757966f97ca4fea9943530"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd759f650f468892693da3cde331ef6f94964cdeda77a5c97b1d49d53417444"
    sha256 cellar: :any_skip_relocation, monterey:       "21c955c695d3357749e20361430adef4880a1e81bcb52718ebc9f458bf157367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a808421b54633091443d6a8b93a8da1ab51874dda4e80b7f8a715aa8b4dc25a"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "zipkin-server-#{version}-exec.jar"
    bin.write_jar_script libexec/"bin/zipkin-server-#{version}-exec.jar", "zipkin"
  end

  service do
    run opt_bin/"zipkin"
    keep_alive true
    log_path var/"log/zipkin.log"
    error_log_path var/"log/zipkin.log"
  end

  test do
    port = free_port
    ENV["QUERY_PORT"] = port.to_s

    fork do
      exec bin/"zipkin"
    end
    sleep 20
    assert_match "UP", shell_output("curl -s 127.0.0.1:#{port}/health")
  end
end