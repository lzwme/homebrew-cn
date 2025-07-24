class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "0a1b9a001ccde90cf870118ccd02a5be4f7ededbac4c8c2ff556f0380cbc559f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6e0eba5a499459004185f254909ad080824863dd7d624c00dbbdf3711e04c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31a4c8f23baf1a19d51a24c0724f687cd0ad6e2b5bd0fd1d95e94864d10cc6b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "761fcea56505e6ff564a6770a808c9ca73681609b672528d543201d638d7d51f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0e0c9455e38f19d0a77c7cd8f80bc80627de2cd248dfe1877e29377fc55bf09"
    sha256 cellar: :any_skip_relocation, ventura:       "7918659acf50c654de62b3e800e4e086ba5c1b103426216c519e8e7ec4a05c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ff8d774462972bcc026112f11e9b537a01e0c3fc1c02ecc6a93b59560fa4b8"
  end

  depends_on "go" => :build

  # Fix to failed parsing config: loki-local-config.yaml: yaml: unmarshal errors:
  # PR ref: https://github.com/grafana/loki/pull/16991
  patch do
    url "https://github.com/grafana/loki/commit/974d8cf5b04c0043ded02cfc3ee360cdff219674.patch?full_index=1"
    sha256 "56a06b0cae70464d738f7aa7c306446f73ceea4badef0502826de9fd1d0c3475"
  end
  patch do
    url "https://github.com/grafana/loki/commit/cc34c48732229f2edf742b5f69536aaa607edc56.patch?full_index=1"
    sha256 "d8f35a91af95d5fe2c1a3c77fa4f2394cb279b88a6c4f8cf22fd2b9d8376dca8"
  end
  patch do
    url "https://github.com/grafana/loki/commit/8ca1db1d24799468c0c6d0cd6b640a60eb246646.patch?full_index=1"
    sha256 "4e2925424bcd7a093f4986d3005c888b98edcdae82b71ec4d71b957f4a9cbcfb"
  end

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
  end

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end