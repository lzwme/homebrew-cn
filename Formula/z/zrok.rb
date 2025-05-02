class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokreleasesdownloadv1.0.3source-v1.0.3.tar.gz"
  sha256 "d7d91457c2d2f31c6844bfade7d850e85125a54f383178bdae31bf44ba8b5974"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa5b4313e672615b3ebe2d5f09cd58fd428c5cece99e9c6c6074892169bda374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249168aa24a7e0ee50186530a18f2b8788a9421743c8303b4fbf4f0247d0ea74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38a7ce0c22c7dd210524f92d10f3119103a0930fe2d02c44c865d75ad9837faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "831a2e671f07abba45ba140bfb3d0a6c78d7dd29b62b9834963666539823e542"
    sha256 cellar: :any_skip_relocation, ventura:       "16793714b2d1c05c3916317f7ba3e905bccb83c34e08be561f0a4ad336cebff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba79dfabfb144b45c351a98a25550b5a148358da98b5a41afe7df095a97c4505"
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