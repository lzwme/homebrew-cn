class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.0.7/source-v1.0.7.tar.gz"
  sha256 "a4f94b95ee7e6464fea5c43a3779219cf41aec14265e5ad12fdad449005b27ce"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7325ef51fd90a7f091a6ebdffa6e2a15b82b0ec376311ce7ac02acaf479a8e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2628a53704535f6e004a3a9b5c038244503972af74720822a5bb6315188b7693"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea91da5e3dd244163359f9139d966f25e3a857e7f406835b50ed1299c2ed57e"
    sha256 cellar: :any_skip_relocation, sonoma:        "51fd315059bba9e7120bdacd9806bd4270349454083113a2684d44d3968ba2db"
    sha256 cellar: :any_skip_relocation, ventura:       "dac24ef9bbd70af181d6fc67baf37bda055fc69da96db59da92d67486558b866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d21f52f12e03170fa68fd92a9e9793945d8a7f33a1430600d1f1ea73ca077a"
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