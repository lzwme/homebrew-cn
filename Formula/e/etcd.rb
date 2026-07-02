class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.13",
      revision: "b0f9ef190952e6e66a778513097a02ee41220727"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e0d1344732330f928cb3494d08dcc4a1ced21427901d9513b9674531a387aa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0d1344732330f928cb3494d08dcc4a1ced21427901d9513b9674531a387aa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e0d1344732330f928cb3494d08dcc4a1ced21427901d9513b9674531a387aa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f058d7558c9a3e1839b72d0dcf2837f96aeb641f26b17a0eba7ab283d3bfc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1cd4db4c13cf2138a8d1987f61e0a22788c045c11d93036ca1486e80b8c0ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee30b9bd774b5add660f94f1ae01a41f0f4e70f30a21ce8c15fa7b40aaa63ece"
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
    etcd_pid = spawn bin/"etcd", "--force-new-cluster", "--logger=zap", "--data-dir=#{testpath}"
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