class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.10",
      revision: "0223ca52b8d6d4953f708e5e4245c37cb4274115"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d58492bdfc2c67821b9b97464535d50664133e6116c84bb710d2a7025b2599f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58492bdfc2c67821b9b97464535d50664133e6116c84bb710d2a7025b2599f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d58492bdfc2c67821b9b97464535d50664133e6116c84bb710d2a7025b2599f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d4f53e434eff24f66ed44e59d772e6cefd9dc6c07beab8d3b73f969be7f2432"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4f53e434eff24f66ed44e59d772e6cefd9dc6c07beab8d3b73f969be7f2432"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4f53e434eff24f66ed44e59d772e6cefd9dc6c07beab8d3b73f969be7f2432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f1f7ad1a27a9b3874bceb5127c9adfd12151cf5ab26c2ce8d7d08f2fdcd1c39"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath/"bin/*"]
  end

  service do
    environment_variables ETCD_UNSUPPORTED_ARCH: "arm64" if Hardware::CPU.arm?
    run [opt_bin/"etcd"]
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    test_string = "Hello from brew test!"
    etcd_pid = fork do
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https://github.com/etcd-io/etcd/issues/10318
        # https://github.com/etcd-io/etcd/issues/10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
      end

      exec bin/"etcd",
        "--enable-v2", # enable etcd v2 client support
        "--force-new-cluster",
        "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
        "--data-dir=#{testpath}"
    end
    # sleep to let etcd get its wits about it
    sleep 10

    etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
    system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
    curl_output = shell_output("curl --silent -L #{etcd_uri}")
    response_hash = JSON.parse(curl_output)
    assert_match(test_string, response_hash.fetch("node").fetch("value"))

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end