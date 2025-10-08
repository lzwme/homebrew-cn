class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.8/source-v1.1.8.tar.gz"
  sha256 "d0b82199ea0e92e1e7a628e63405f0adee3857009730a355db90f428d4a53dbe"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69512d5888b0ab4f9a81010b546c4d1e7b48b52be839c8ff1cdd904a9bb1d7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05e06ae818aad3085d6355b062867dd7517de0d83a6440cf2c8eff8be77b55b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9fae2c6df5e753fd5d9c9709f85aa9315b0d2606c13b8d755e259190c80aa75"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5d63854062aa78cc4f250d368821f7f52dc39503a6d3e3a8cb8554f41fa354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a013fb99a8f02f968b31c13b254740e1190bcd806249780762913d39e853bc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ["ui", "agent/agentUi"].each do |ui_dir|
      cd "#{buildpath}/#{ui_dir}" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=v#{version}
      -X github.com/openziti/zrok/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~YAML
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    YAML

    version_output = shell_output("#{bin}/zrok version")
    assert_match(/\bv#{version}\b/, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end