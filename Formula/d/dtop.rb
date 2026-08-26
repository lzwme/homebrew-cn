class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6ef13284e757379fcc2c6ebba5c9676338ac0ec3df629196896e63b2b4ffe063"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41bf93e0f62ec1f5347c2644c8decfcf8427f804e01e65c72c33fb2fd9e12cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea7d7d92c7088777132b1b3230a9308782578acb1502cc9f1e8fe5e4a562f5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2070b44ef2c5bd87910b184e4438a1604cffe9aae2f4b861b15ff61891895b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadfafdccf459b269845694315567ecfdc5e0590e772e1e45610c40fbcdd3611"
    sha256 cellar: :any,                 arm64_linux:   "4b679cec15e43d329b8d8f5bddc220bbeda06f82f12b283676319ac7965eb02a"
    sha256 cellar: :any,                 x86_64_linux:  "f9de02017a4af581690a98007063cdd63dbb87beea26cd8f79d923b585b102a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end