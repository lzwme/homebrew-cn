class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokreleasesdownloadv1.0.0source-v1.0.0.tar.gz"
  sha256 "2980581c45514240598135deed8a999bc65359527ded31a5bb855d05e70f2254"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  revision 1
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7aa5f6d29e3cb5af602fd845f34404f43c4495e03896001f8836196005c1c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef624440b9ea50d95dc834a7b3980088fb5d3f45a93d22071f1705b978d8a5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae096032a1faeb5b6a2b24aea888e20d4705131032b12d2ffd1b675c94190f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2d884eb55636fdcb590f00d4cb607c98edd0aaec9529c0b5441dfe4ac0f20f"
    sha256 cellar: :any_skip_relocation, ventura:       "65027a113a959f0ee8d3665e92f8e38d569760666a149e25fbcaa058d9633262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da8cbfcbd4d0e3fcf7d340a3a5295ddd8db3c35f25aa72c69f5a600b9af3965"
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