class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://ghproxy.com/https://github.com/influxdata/chronograf/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "d8a27ec44b4422da87fcfce22adb1227adcca6515e72a04dbd28876ed232483d"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a25c0fb19478a91aba0d01425493570f4688706eb747322985e5460ce41a00a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3bea8e695c8d0cec4e82ebf5ea5a4a1087c07e11fe63560b053cbcd58191a9"
    sha256 cellar: :any_skip_relocation, ventura:        "988b458e02d84790b924e821fd3b8811c1dff0abde7b7889e16addef16b94f01"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9ba175b2a8cc8667d5d87896b4451191d6e7a97815b590f99b3eb6e0d59ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60df6e8ac060c779920a4dd7e4b2bae17bbed21a05f976875089fe16f7c11744"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    # Fix build with latest node: https://github.com/influxdata/chronograf/issues/6040
    system "yarn", "upgrade", "nan@^2.13.2", "--dev", "--ignore-scripts"
    ENV.deparallelize
    system "make"
    bin.install "chronograf"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"chronograf", "--port=#{port}"
    end
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match %r{/chronograf/v1/layouts}, output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end