class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.1",
      revision: "a4708beb0f5dfba937145762516ac98f15797940"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5debf906d36e65bfdd936fdf3b651b4877a19d68989ad099cbb5b27d14086c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5debf906d36e65bfdd936fdf3b651b4877a19d68989ad099cbb5b27d14086c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5debf906d36e65bfdd936fdf3b651b4877a19d68989ad099cbb5b27d14086c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ce8aa68745fc23294b4858e1ccfeb45c6b745dca4bafbef7013bc0502d815b3"
    sha256 cellar: :any_skip_relocation, ventura:       "6ce8aa68745fc23294b4858e1ccfeb45c6b745dca4bafbef7013bc0502d815b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09d9b69ee4e12d87d2fac5d8dc5e2f9c79dab763aca591264e2fd57e4ab0f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625bb6f50e2ee4ff0be818f89327da7780dd0b2ca1170fd63287e5340c46b154"
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