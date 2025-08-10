class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.2/tika-app-3.2.2.jar"
  mirror "https://archive.apache.org/dist/tika/3.2.2/tika-app-3.2.2.jar"
  sha256 "7b6da1143ea867fc162e1397bfde904a3ee059491fa7079383b63dbad15a38e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e81b0183dc5cc06347ea24e1e04f553d12effd10e8b60ad6372d474b5b797d5"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.2/tika-server-standard-3.2.2.jar"
    mirror "https://archive.apache.org/dist/tika/3.2.2/tika-server-standard-3.2.2.jar"
    sha256 "04bcb61826403957cfab93cb1e14d4c305fbeb949475f031b0b73dab7e976995"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "update `server` resource" if version != resource("server").version
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  service do
    run [opt_bin/"tika-rest-server"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = fork do
      exec bin/"tika-rest-server", "--port=#{port}"
    end

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end