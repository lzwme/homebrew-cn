require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.37.tar.gz"
  sha256 "629ba01bdb9862d53a01c9245858de6f4cb31b7da6ac6dc0d80e366df5009ec0"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91094e8142cbeaed47f2fff41a10824091bebb7206a98d1b13266fd645ad054a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b530aff42b60091d59269aa2b668eb28ff416850186170c498bb8f73bf0d7795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d1ee639338769e38bb7a9243c6166fa0107212215dcf09c923a1096482d267"
    sha256 cellar: :any_skip_relocation, sonoma:         "20b058275ddfba30afe65f1f8ef5df94442e62666d0aa59ab9a45712d17c3ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "3bcddb21f3e741f608e4503837e834ee2e2703c30d0d1d157f212e8660c4ac15"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c6e7ce9e39734831cc8e8ef6db1afec4ef39d9463f5062c3a03986ec5fc352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8f3d40e1a7af6b3789ab19d5dde5e8a810245b8890f3e76ffd18444bbfe9a0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
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