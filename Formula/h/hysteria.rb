class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghproxy.com/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.2.0.tar.gz"
  sha256 "d3e6809ac2b8e1c58e1c95cdb96bd44d99b17c7824bdd931d4d51c9e3818d402"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd1667c9f60649a02c8dbc3837edf4b6ff9ebb4e731fd90df03cd07d371fb9bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8224d60ff4bce63bf95989d7781218bd70d615d331948609ec37d09cc1a4b7cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3178de6516b929129b15cc965fd8a8d1f8e7977d6a68aebfe0a445f4d51713fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc4d66026de7d1dcd4dde5c039306c606f96b9d13b4fd111a8a58de602569d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "077168c29b1ac45f0ecc832f130dc537cae6daebe9f4b4e399e6eb3a3f89be26"
    sha256 cellar: :any_skip_relocation, monterey:       "bfec9e47298a31e2ac6a8cb2f056740ff62e83808daf263a0baec3ade7ca6b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27771575aab76b1e20527b4b40c03236beb0bf2cdbd1d979ebcb9cf488c8bf8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/apernet/hysteria/app/cmd.appVersion=v#{version}
      -X github.com/apernet/hysteria/app/cmd.appDate=#{time.iso8601}
      -X github.com/apernet/hysteria/app/cmd.appType=release
      -X github.com/apernet/hysteria/app/cmd.appCommit=#{tap.user}
      -X github.com/apernet/hysteria/app/cmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.com/apernet/hysteria/app/cmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end