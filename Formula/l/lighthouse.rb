class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https:lighthouse.sigmaprime.io"
  url "https:github.comsigplighthousearchiverefstagsv6.0.0.tar.gz"
  sha256 "9eafb6654deabe3e10602daa99a34ec9db1ed83396fca7de12ad2deb05915860"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478ef81622db566b6ad87b4b29ec57f6af9dd0736326b75e82f3891aef1a2472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee33df7b1c0034290306aa3eb020633b748ad9df1c692aa7137e4473bf74a74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aca5171cfce34858ad513a8fba0021f182a8f6ba710e563de3b2e42dd936b8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a60358f8043f0b01c08ebb299bd1f7cb4ae1168fce31fa942aa9f9aac7980e"
    sha256 cellar: :any_skip_relocation, ventura:       "d6a67d65545b9eef6ffb70f4d89c198c9345d74bab15fe4d2b462a833bd4663d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253dbece9532ed9a9718fe03e6ae405be7d8e15b089176c8d9c7a5d1560a410a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: ".lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}lighthouse --version")

    (testpath"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http:localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http:127.0.0.1:#{http_port}ethv1nodesyncing")
    assert_match "is_syncing", output
  end
end