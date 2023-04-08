class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.1.0",
      revision: "3649832421bff09b5e4c172b37dc61027dac0869"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fa7cb613f7c15a30d7bafbb876026982d6079e6ad722427966eae689bc86990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9c3cf07613c9d57dd6ed3e49a1ecbd2cb8496a80555f66f211b3dabca26071e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d15c5d848a28f099be6fc2c668795b0ace664f926229cadb7f528f80606f83"
    sha256 cellar: :any_skip_relocation, ventura:        "f9babf710fe60fabb79156701723853732f6d941e58610a8a1f398d55bfaef0e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6af9536c71efa4e25c42a21d88609f5c2e5c95dd2a7b1011c2832a6ac42cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbadc30a811280de48ea451d2679299553c5d9cae0d8cab23240b1ad44bbf0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550ca3e112506957bf144242ea0d98bb6c5a4b71e4bc50c799061bdfaa3da221"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/v2/driver/config.Version=v#{version}
      -X github.com/ory/hydra/v2/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/v2/driver/config.Commit=#{Utils.git_head}
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