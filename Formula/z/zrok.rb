class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.1/source-v1.1.1.tar.gz"
  sha256 "44475b93d3cba825d6601fa8cce18e29c9bd0cfecc5b0e646e0987304f53691e"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91bc294f67176d7b8e90d0fc618f23ed44e1eca233c31bc379d98d8b06936f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e183af12b107d8ca6ae96f04c98d7f48b34fc167f60a13e8a0049d8e45bf907c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94aee73c18e0223bde7e5260586a6c59d33cc9a9bd384013e1765484db71cc6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b102516456e822931acbf9d70bae187510d9b0866411d460b8f5e27e5ab9a1ba"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed6b09034fd1a781905fab7e9ea2b00cf9623f5e3c67286639676554e822e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6271b41c1e04b30b0a216bb1339f576abad896c91d14f42f33c7b4df005f09b"
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