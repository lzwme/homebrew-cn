class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.9/source-v1.1.9.tar.gz"
  sha256 "b0c0aed2bf78df89f57a505006d9edd5b67a9c041a348b50a68d0c640800d6e8"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc1a5364f6d72b5b061d85135a7e0d49dbef451092125cada8fe1e19f30bb37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02731d76cb6fbd28780cc8182d1bec22e309a72336df5438871b6fef38ca22d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdc4d2654362b42d928ae2d181703acfd82da37cadff6bbec3c0211d2fdcf09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c9513e50ba5acc8737b6fd71dbdd49180e2ca79e92e2f4df8acdb68635fd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc3f12cdc076c8e3a23f8b457150a001f20d9f008d34038703323c2e22e46a3"
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
    assert_match(/expiration_timeout\s+:\s+24h0m0s/, status_output)
  end
end