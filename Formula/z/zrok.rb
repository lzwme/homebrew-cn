class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.3/source-v1.1.3.tar.gz"
  sha256 "dd0df7a544bfbc4e358b46e1d14819546a518886ab5b27ea0ce3aa43e76e84cf"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c303c73b1777a89437e01437f971e03a993ef5d4c297e4fcad2c9a6fcb98b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d989bfaae3e1e9add0f96dfbb8504453abe5ee9df6868e5894da55c196b2e017"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef442380787be4753cb78c89b7ce2f105fba325b8d0e7846accf52a25d1ff679"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c34239268a5999e5b3c8379d6b04c418384503c6c379c1765d51df67572aca8"
    sha256 cellar: :any_skip_relocation, ventura:       "3dc7da34cb6def26300419b7a80cdf7bdb688973620ff0ee8b3f41765c7f6e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7572c9369573db5743194aeecbf7ed3a6734c8c85aa529448534c4d58c827e1d"
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