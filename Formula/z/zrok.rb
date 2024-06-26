require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.33.tar.gz"
  sha256 "f5bba8591b56ee550467df90280da917cd9b2a2b8702a5991a9ed1bb651c2235"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3ceb9ab8e8f88a421caa8f3a9d82a1293c0b58c2084a0699f161133ba89898b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fac434e555d0082cd23282102bc1b084fcc448d89a30321ee60e0eae28c4ce3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e18da7050b4a739d6ce7939ddc273f5dc5119d203a750d7fde1c430aa9764f"
    sha256 cellar: :any_skip_relocation, sonoma:         "66a8bae284059bd9ae0e9c695c224819dddef7495774b0a0cff2a8324574f0d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d6a453710dc4ab83c746ff1e6dbe83bdab1ac71f20cabf585e26de76f59a9031"
    sha256 cellar: :any_skip_relocation, monterey:       "27e72b1dbd69c9458d24bbca23eea301456afe1ddcfe3a2bbced6e9cdf597288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3256b6e963474bac5c3939005776b4036a4af732eb69c80ce6ac3f550861a0d4"
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