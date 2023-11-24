class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghproxy.com/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.2.2.tar.gz"
  sha256 "b4088f9ea4cf1299a1c372b39a088063e57d9dde61dfdf2a3ca7f04b89bc9536"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c9215d37580d13082b7ee495bd371d4df50d17512057c189153805b7afd36ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c03db334533ce9855758200b560beacf02480be334177085d02c8829797c5169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24fa4e63fdbe1c2b849f076690b71c09d667c1624e6899919cb12f96badff86e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e063b2455eae1023e83f06ba24b1ec6fa52a3512b42044b8b4e2af4146e51c4"
    sha256 cellar: :any_skip_relocation, ventura:        "55488e7a0f690d07ef0f99e38935d1874c2f54383f560f8575651dcfb2e7f9f5"
    sha256 cellar: :any_skip_relocation, monterey:       "a9fff4ce90a924cb284a956ebfd89f3d616a60565b03ba4117e8ee8c54e9d0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f7181110e06b5fc394710c2c369370a457fc9fbacbf6944598281f55dd5102"
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