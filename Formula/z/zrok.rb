class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokreleasesdownloadv1.0.5source-v1.0.5.tar.gz"
  sha256 "1a18e3c04038c02c40e15c107d4bfc240009911e4529224a78e6bc2d0fd9b66c"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5183020d3d78d3e9b2e7ff20d90e5d81fc6227685fcfea5cd4fd4ec1ba05a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6215eb4bfb6d71325108005256aad15ab35b2fed1341d4c59d87513d84dd4c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ea096ac0c14de963cc16101b7f7291e9a3b37d5f90ee4ed721d381a10862028"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e61d8f66e15a2ae28a31e99c25b6880132d4b822c03508256927a3ffa58ec5"
    sha256 cellar: :any_skip_relocation, ventura:       "4b089fc18baf18a535ee6a3e21b4d3cb0fbc937613136a0b822c92bd8c301aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5895135891bcd5a3706a85f25308fc7bac01773da013ecf8d65bfa11cf59133"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ["ui", "agentagentUi"].each do |ui_dir|
      cd "#{buildpath}#{ui_dir}" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    ldflags = %W[
      -s -w
      -X github.comopenzitizrokbuild.Version=v#{version}
      -X github.comopenzitizrokbuild.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdzrok"
  end

  test do
    (testpath"ctrl.yml").write <<~YAML
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

    version_output = shell_output("#{bin}zrok version")
    assert_match(\bv#{version}\b, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end