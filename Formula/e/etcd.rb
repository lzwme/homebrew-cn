class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.3",
      revision: "1ed440dc2be4bfcfb06aa1f83a5114727438eaa8"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92919ad55bdddd32d0b32bec39fe02ff92ffc08b10d0ec982b9b83b65566c7c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92919ad55bdddd32d0b32bec39fe02ff92ffc08b10d0ec982b9b83b65566c7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92919ad55bdddd32d0b32bec39fe02ff92ffc08b10d0ec982b9b83b65566c7c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec95d5acd32be3f228f3e75cb626f010268cbfdca7629f9c9058d6284e1d6925"
    sha256 cellar: :any_skip_relocation, ventura:       "ec95d5acd32be3f228f3e75cb626f010268cbfdca7629f9c9058d6284e1d6925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b99eabd3c8a34a85dd5c36c3d83c4fccc909aeaacc074a7c906892905c08ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd513331da222f3c3c3df442918a881938df88bd9df8b7e6b29c18906d95868"
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
      exec bin/"etcd",
           "--force-new-cluster",
           "--logger=zap",
           "--data-dir=#{testpath}"
    end

    # Wait a bit for etcd to initialize
    sleep 10

    key_base64 = Base64.strict_encode64("brew_test")
    value_base64 = Base64.strict_encode64(test_string)

    # PUT the key using the v3 API
    put_payload = { key: key_base64, value: value_base64 }.to_json
    system "curl", "-L", "http://127.0.0.1:2379/v3/kv/put", "-X", "POST", "-d", put_payload

    # GET the key back
    get_payload = { key: key_base64 }.to_json
    curl_output = shell_output("curl -L http://127.0.0.1:2379/v3/kv/range -X POST -d '#{get_payload}'")
    response_hash = JSON.parse(curl_output)

    retrieved_value_base64 = response_hash.dig("kvs", 0, "value")
    retrieved_value = Base64.decode64(retrieved_value_base64)

    assert_equal test_string, retrieved_value

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    Process.kill("HUP", etcd_pid)
  end
end