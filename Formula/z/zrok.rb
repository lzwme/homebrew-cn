class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokreleasesdownloadv1.0.1source-v1.0.1.tar.gz"
  sha256 "31ad43670d3c7e8fdbb89b62f8ee8d16ac5e7d28aad5fed7919933e17177f054"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdfdde6b33b8b52fae001b52f5931cb42ea2f553a76185928ba2ad230641cf43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b901976e32d0977c0d1fc0cad87ad8b07cf8eadf8199fb055621253d7343a4d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d34211a49d71aae0bdb8126ec88cf0078113c1c33c5e0d4c9e735fd8209c05f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "01fda32766e81ad823488acf0fecb8d972f74308e4e69f00d1b85a68f0883a90"
    sha256 cellar: :any_skip_relocation, ventura:       "afdcdc1d0679c6cb58c1a76657602b7cd92ab11e70ee1c35e111ac4531c53020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e567f814699d11cb6838573ae8660454a03524e80b39f70fffc4afac6f608e6"
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