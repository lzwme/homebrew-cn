class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghproxy.com/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.2.1.tar.gz"
  sha256 "04e66404575ce680276aa485cacf42e6c488361e955c1ff89f0b2a070695fe3f"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f256895f5ed2827b16434b350759e29a495119dc9efc9222fc5f8b7339ca509d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "630ecf742b94b51eb2a31d4e89065d8490be5422d74c7b0116489ae7c0fe88c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9cf87b8f4053383cb17ee546a9f210c4f73f0c8a7d7d9a7d0ce28bfbb7e4209"
    sha256 cellar: :any_skip_relocation, sonoma:         "336fa74d209c9e2c26daf8f0c9daf195d8b116c9712b0959a9d37304c507e0dd"
    sha256 cellar: :any_skip_relocation, ventura:        "8fd1e578fc5e7598b17d9f62766618e3ef7d5dd41939eb4fc6720ecdc3aace61"
    sha256 cellar: :any_skip_relocation, monterey:       "46c2d892d9c5e4ef43fb5ade28e01ee15734a44bf1964390ce9d2e8eb50a9c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3afd0c5aa6cb0b284b1b718c4d0a276eada1b52209867db3a4cc8b1c5883476"
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