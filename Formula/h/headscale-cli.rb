class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://ghfast.top/https://github.com/juanfont/headscale/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "9ee04c5ade81fc36ed83e3a6d5ed28e9ab25e8ceb50f64ea7fa9a62394dd1cc8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39c180a34f48cf8aeee6fc7beba84f8728d11a9bca631b8670e5e7a7f5e963ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ee0f77a646e178724b1de75796c036340257f5e6ccb79e872ea537aa6a86ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063d6a6da1280b38be7b6f7f391e4d1f3f3ff5f7e10fa0527c471e117ffb7cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a5ea26c7d12336d5eca8f7246f3eebdf8b77499ac45c137dde3b687228b02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f4d79336c3ce923c9dc040263ad5f7f73a3a1a7d1a819ef72798faf4e2584ac"
    sha256 cellar: :any,                 x86_64_linux:  "4a886ced23974cd52404573ff3ad9cc7ca6f6b4d933cbf18adb53373cc6a8686"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"headscale"), "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      server_url: http://127.0.0.1:8080
      listen_addr: 127.0.0.1:8080
      grpc_listen_addr: 127.0.0.1:50443
      noise:
        private_key_path: #{testpath}/noise_private.key
      prefixes:
        v4: 100.64.0.0/10
      dns:
        magic_dns: true
        override_local_dns: true
        base_domain: example.com
        nameservers:
          global:
            - 1.1.1.1
            - 1.0.0.1
      database:
        type: sqlite
        sqlite:
          path: #{testpath}/db.sqlite
    YAML

    output = shell_output("#{bin}/headscale configtest --config #{testpath}/config.yaml 2>&1")
    assert_match "no private key file at path, creating...", output

    assert_path_exists testpath/"noise_private.key"
  end
end