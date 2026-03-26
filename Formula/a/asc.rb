class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.46.1.tar.gz"
  sha256 "7069ed0a3a791f6375ed11b0d9aebbfa4ab7ef8387b5de2e784d95abdce57e2e"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64d9df268883740906958bc69aba09c4e6ffeb3536128fbec938349443178032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca5188b169c047779c7e9039fd891a6402a0c2c11e2897e8c44d6717ef38817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1625626062af21d4fd0d2b115885fc35604c244b3b895a3662b0cc6792ac1c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "59dfdf46fa175f8ed70020d2c2adda26b976a082a41694e58543714ad06c2ff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6c1856f272de8535a28680cf899a25740ce430ab54e37dde6cb1b7c6f13c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ee09776b218b99ddcce9be9616e4f8d87b7b90ade0e1c65be9ec80ef2f711b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end