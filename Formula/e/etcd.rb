class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.7.2",
      revision: "68c065e562994b89e333e77b039ad066f933c586"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "192de1e359482ae9ddaa61e3db8c987f0ef6cea858f482764f327c921f600c15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "192de1e359482ae9ddaa61e3db8c987f0ef6cea858f482764f327c921f600c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "192de1e359482ae9ddaa61e3db8c987f0ef6cea858f482764f327c921f600c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63885bd00a4038770db8e83df4f586fcc1f2cf92305470fd955e03d9b8b5d289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b86918a74aad1d2b8ea9fac622b2a00a4d84dca1098d35929ca8076e7a84612b"
  end

  depends_on "go" => :build

  # `test do` block runs a local etcd server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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

    key_base64 = ["brew_test"].pack("m0")
    value_base64 = [test_string].pack("m0")

    # PUT the key using the v3 API
    put_payload = { key: key_base64, value: value_base64 }.to_json
    system "curl", "-L", "http://127.0.0.1:2379/v3/kv/put", "-X", "POST", "-d", put_payload

    # GET the key back
    get_payload = { key: key_base64 }.to_json
    curl_output = shell_output("curl -L http://127.0.0.1:2379/v3/kv/range -X POST -d '#{get_payload}'")
    response_hash = JSON.parse(curl_output)

    retrieved_value_base64 = response_hash.dig("kvs", 0, "value")
    retrieved_value = retrieved_value_base64.unpack1("m")

    assert_equal test_string, retrieved_value

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    Process.kill("HUP", etcd_pid)
  end
end