require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.35.tar.gz"
  sha256 "89a2160e3f2584e6ad1bf6f28bb4e8d43fb498ab783c12332594a16bb3a43b9a"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84c079cc9184d31d93c129cd585e2250db9c9c76399e3c5ebf927f4b884cea37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d14e849a9d84044ecec85d6779c2853caae89fd06507053e0442eec0afed7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc2eaa0e9482f2426917ffb4a452367990993d9428d8e637445ef6bacf23a78f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d68e84170445372c40ab8ebbb53949c5f220419172d0aa730b02d58289bade04"
    sha256 cellar: :any_skip_relocation, ventura:        "62d14287414a153292cf6c937bcf3149613ec85a411bc6a1f9067377613e397d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb5f9866c78b3523992093d1184adda45e38d4aa8c52f21363899ee180b1311f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9ae84336797da40142c3a8a66e64c612088a87c35a1f965800f0fe742c7077"
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