class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "a3ffbdc68f3481444c16a7733e4640718af502bcef25d592e77d03da388c4aa1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0075f2c531c25a039c96348ee904e2c8c20f2450cc42ea5eac4f81299ca679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7505b20293127d93e94a3c9e5f7efd2c2f51cabbfdd9f8d8fbfb2004d4ea44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e7e2e14ad16d6d198102322d98252374e50de9e53f83490c84fa20ad50be9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb49d02c536517eaf1a42871964073176b197facd8fe5bb21901ffb261e69f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8848f2871ab30ae3378caf366e1eed98259da052189c1bc06c83cbd75c0341ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cbcf6b72e7c070bd381348925961f775f1b2c82a31d2fdec803a2d58602c394"
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