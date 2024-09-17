class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.40.tar.gz"
  sha256 "dcec641cd0932c426eba0285308b19330714c186e800fe7a6470d6af38e6d403"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f7a2d041425db1cf6963f92fe1241b1b22bd96566d4ecbf13ea8accfa205cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61141b95f9bfbe255412088290aa2c1898422c33471dbb9a49de2839c85ac5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cb47dc3a4a35cc4d2fdfc6a227630552bc4af9a5ebaeb2ff7fa946ef82f1ef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "00fb3b36ca00b41275130397552d827e03b11b89be9b158af31507675ec07a7b"
    sha256 cellar: :any_skip_relocation, ventura:       "c20f83ce46599e469342f29e5138e12fad34b1962972a06e87164dcab9526443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57338970d49df24b6cee44136710468bf7efcd53d371b1179ba7a7dafb9f5983"
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
    (testpath"ctrl.yml").write <<~EOS
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
    EOS

    version_output = shell_output("#{bin}zrok version")
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end