class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.0.8/source-v1.0.8.tar.gz"
  sha256 "f0de8398deedc82b0dcefda3beb17294a5465394be68147dea2b95a1db58e999"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f616625b51489bbb274a3f98af43a6c575554f5b20d33b8061b8f934813a12b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83edae86e46515be824d156e04a5cd2f29bd0d34cec35ab9b42025f174a998aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc7c2caf36c6f54acd4f4c1098a32b5028f39b5e77fd1cba8d68c70140623012"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7bcda155acee996e3d6fe3b546a803d75d728376b13630dbab18ea8c86c38f"
    sha256 cellar: :any_skip_relocation, ventura:       "595a151bc2e2b427bd5803595ef4b9cd58fb1d9514a349aca33a60263f72056c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619d31c4271c4ed6a49f5cd5206310a990674d4ce27ca66092b6dca0c31b5106"
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