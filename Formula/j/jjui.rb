class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "afe36a38e9f6cdbf9cc4096ba9ce9fd1251128ac5f26cb783b7de8246cbc3d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d763e7ed35cfe0d9c20522ef5b05351c04a0fccec95c11fab32523fe760c6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d763e7ed35cfe0d9c20522ef5b05351c04a0fccec95c11fab32523fe760c6b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d763e7ed35cfe0d9c20522ef5b05351c04a0fccec95c11fab32523fe760c6b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4ddee09f0cead1c8af7f45ecc12541a61f6b0b20f74007e9bb9c6ca1dd9103"
    sha256 cellar: :any_skip_relocation, ventura:       "fd4ddee09f0cead1c8af7f45ecc12541a61f6b0b20f74007e9bb9c6ca1dd9103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5537c4f961a567b6e9cdafff1d7ac4df9bb7d760087efd02ec875b0d8bd7a7e8"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end