require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.36.tar.gz"
  sha256 "88cccbfad3e35d00bd8c0fd5516b44649be0c63c73cfe8d9bc035bd7e07a1c9a"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ac3e1070e56ad6057356b5138c0da3b8c82ef2a6631003ca607266d7c8174dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78a691df1323e80eb42037509d5d269f8f9507b90edac9a1f5a1f3091e6e8f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55afc7864ccb8e7564fed3a0efc367d7f5777316d122be43605f522c70213e9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d22e97eaead935ad5be06d1e19ef8ffe1b0b09edb0dea5c426e723b938efd9fc"
    sha256 cellar: :any_skip_relocation, ventura:        "2b442923c752cb06735bc7cfff303bb6cac7754c2b5929f181368810cc32d51a"
    sha256 cellar: :any_skip_relocation, monterey:       "01009cdda7ded76f1f32ffb34a2b81166a78f89595ab4796c80813618b5ea14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43277cb06a4f4b1244c5f6700c7fa3b664a96e6f8c65c4aca0f3efee8fdc714c"
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