class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.2/source-v1.1.2.tar.gz"
  sha256 "8ed33dfd63532da4d69d5de0edd60e3768a02b2a87b8a046aca0daa1fe00df75"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca707aa7227b0e22c3767383be7ae473d9cb4ed071054931b3e7dbf05a62b24d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a1ce10e234c76e4d80a098cd2089c29616687d8e9c7408f6bf3058d884f92f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d5a49a3d55d0b1f0d09d8eb3a5dc04a52e2550f18d6fdcae8257eadcca70d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48fedc085f5947f1069b60d66f618de08ff9395ae38a45204ac353b6ffd31051"
    sha256 cellar: :any_skip_relocation, ventura:       "e6c4a043452d3c8216243a987e9006bb7f6c9cdd6b45b3a1c0ff273855d715a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86628b215c54539eb719704493fd229427a7556b7c5bfadbfca27458fcc6ff55"
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