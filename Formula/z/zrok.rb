require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.32.tar.gz"
  sha256 "49b1a67ded26df5140349e1de5a915be809fa6fdabe5dac3a58ed0d20e2792b4"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c7f717df5319e4a8a3b30062c07638c470d603a732141fcbcf1ce5c04b34b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2740dc78b9c381366faf36f442a5ce68a577352f3e0f4eb8496c32ef2319a2bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a3bf247212cb7ceca4418d70c2aa43af2780a0b59d5631c622608bfb5822f34"
    sha256 cellar: :any_skip_relocation, sonoma:         "06be2223fa3a2976b4c8b59adb8fb23981c2d82a6bd5d51e48b914d03c117c04"
    sha256 cellar: :any_skip_relocation, ventura:        "0b11edeadab4111f0bacb67ad6e23eeadd7af91d57f06f2d081726bd06e1ddc5"
    sha256 cellar: :any_skip_relocation, monterey:       "6e2573324eaedf8bf5dca8af043e719146b4ac0a004f7ff461600229bad4cd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1f5fc726e4b5cd0563713ea40f8b2b11849254b191628b3fca66be380b34984"
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