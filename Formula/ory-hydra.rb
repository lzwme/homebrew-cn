class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.0.3",
      revision: "16831c55c41e64dd73637e8e2ca8f22202fc7d87"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61571ebfd7601dd05cfe0f3e5e9f5dc470ed88c37212ae13ef9ffd1c443e1275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f12b8a5e6f594c6308dfdfbeaa02c22d9e52a805241afb55726512c13d25c80a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e8ebcb43ee967b5a9a5af9588f67cd415cbbeff8c907a936ebfeccfd2ce191d"
    sha256 cellar: :any_skip_relocation, ventura:        "9672ab575aac913f6ffdd299835cc6c61288d03c58dd5f3675bb6cc44e80e55b"
    sha256 cellar: :any_skip_relocation, monterey:       "eb368d75f979b0a59c8149ab07b2ddaace682b6b43e59e9183a8861776e2e649"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8851259d9c64bc8204f78d87f922c7307a71c570cd606ebda396d1a21bbe4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe6a980bd7f7ecd82b8eb12244c2484eeee7713c355cf251f41aa3186101e41"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/driver/config.Version=v#{version}
      -X github.com/ory/hydra/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/driver/config.Commit=#{Utils.git_head}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "sqlite", "-o", bin/"hydra"
  end

  test do
    assert_match version.to_s, shell_output(bin/"hydra version")

    admin_port = free_port
    (testpath/"config.yaml").write <<~EOS
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    EOS

    fork { exec bin/"hydra", "serve", "all", "--config", "#{testpath}/config.yaml" }
    sleep 20

    endpoint = "http://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra list clients --endpoint #{endpoint}")
    assert_match "CLIENT ID\tCLIENT SECRET", output
  end
end