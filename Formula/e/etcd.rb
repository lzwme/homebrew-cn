class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https:github.cometcd-ioetcd"
  url "https:github.cometcd-ioetcd.git",
      tag:      "v3.5.12",
      revision: "e7b3bb6ccac840770f108ef9a0f013fa51b83256"
  license "Apache-2.0"
  head "https:github.cometcd-ioetcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d92b08ff9b79d9eb183c23f7bdf8f272f0608bae5740dfe3ce6d822dc9886243"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92b08ff9b79d9eb183c23f7bdf8f272f0608bae5740dfe3ce6d822dc9886243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92b08ff9b79d9eb183c23f7bdf8f272f0608bae5740dfe3ce6d822dc9886243"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dffd1bd284c2081ca5fa03aeffb54ebfed0f9c7429ad450650329b764c38f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "3dffd1bd284c2081ca5fa03aeffb54ebfed0f9c7429ad450650329b764c38f0f"
    sha256 cellar: :any_skip_relocation, monterey:       "3dffd1bd284c2081ca5fa03aeffb54ebfed0f9c7429ad450650329b764c38f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7409473d7735f870dcc823272796672771de30f2099343dcc94ae05627733c"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath"bin*"]
  end

  service do
    environment_variables ETCD_UNSUPPORTED_ARCH: "arm64" if Hardware::CPU.arm?
    run [opt_bin"etcd"]
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    test_string = "Hello from brew test!"
    etcd_pid = fork do
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https:github.cometcd-ioetcdissues10318
        # https:github.cometcd-ioetcdissues10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
      end

      exec bin"etcd",
        "--enable-v2", # enable etcd v2 client support
        "--force-new-cluster",
        "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
        "--data-dir=#{testpath}"
    end
    # sleep to let etcd get its wits about it
    sleep 10

    etcd_uri = "http:127.0.0.1:2379v2keysbrew_test"
    system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
    curl_output = shell_output("curl --silent -L #{etcd_uri}")
    response_hash = JSON.parse(curl_output)
    assert_match(test_string, response_hash.fetch("node").fetch("value"))

    assert_equal "OK\n", shell_output("#{bin}etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}etcdctl get foo 2>&1")
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end