class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.44.tar.gz"
  sha256 "b182117773177f40ba8f44f466d69b46c0a58ba6f3ccd94cab916ce164e5d353"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8de4df59d0ee6a27f39ed4c7b7165804e22b3750ec05c4677e11c867c552b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2098dc6b1fa488c77999a77242db2763f36b73c29a55f3105ce5a7dba52c0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14950cec181b8e5f820056b6b171c588ca2f1511eb9ed3e80339ec571eeeef6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3399c71044315cfe768d7190a50fc015a666ebc32d3a49da1a5f760a2a58c895"
    sha256 cellar: :any_skip_relocation, ventura:       "fa91c874d98e11b590dc08a1ee11df161cf226c7988adfd8b0c0832624cebbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc35dc13bc9f30be2b4c76199423e7235bd09eb5bc8f6342783e0980046669b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath"ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.comopenzitizrokbuild.Version=#{version}
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
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end