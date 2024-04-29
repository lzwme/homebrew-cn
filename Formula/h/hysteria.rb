class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https:hysteria.network"
  url "https:github.comapernethysteriaarchiverefstagsappv2.4.2.tar.gz"
  sha256 "d48c3ae0746355247e227542075417801cf54f75ef4152078841a0d9c07de626"
  license "MIT"
  head "https:github.comapernethysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd8baebb9b8f46bdc92fd7358bea03b909fb15a53ead6cde1cb6c613c445f068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1d0083184df0116a325c8e90a5e6dac1eb0a9a73eb9ba72ba88cef404ed291"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a50bd7a9f314f1fc3673c97b2729a9d263f4a5ce8463c6211f172aeca1b7c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "61edb88ba30826fecd0ef363cbfe21c0401001552eb47d82ea9cb7ceadc993d7"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4600c7dc8f4fd08feedc68346845ac526348c130df32944b092287bcc880d9"
    sha256 cellar: :any_skip_relocation, monterey:       "6861118af53bb91e845947f14fac47fc04404e90da09183fca00b4a4525cfdca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3ea49523bfafd8685e609a505032494ae749d5098d547a5b48c045ca949215"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comapernethysteriaappcmd.appVersion=v#{version}
      -X github.comapernethysteriaappcmd.appDate=#{time.iso8601}
      -X github.comapernethysteriaappcmd.appType=release
      -X github.comapernethysteriaappcmd.appCommit=#{tap.user}
      -X github.comapernethysteriaappcmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.comapernethysteriaappcmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), ".app"

    generate_completions_from_executable(bin"hysteria", "completion")
  end

  service do
    run [opt_bin"hysteria", "--config", etc"hysteriaconfig.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath"config.yaml").write <<~EOS
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
    output = shell_output("#{bin}hysteria server --disable-update-check -c #{testpath}config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}hysteria version")
  end
end