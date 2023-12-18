class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https:ko.build"
  url "https:github.comko-buildkoarchiverefstagsv0.15.1.tar.gz"
  sha256 "d8ccbc52f4495fc142a6e370fe0395d729afa72c8ffa33b5b2a833813dfca7c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6639baa6df66bfed83f2c4ead2e2a36be8dca1e9c35df3ae96ea9e3f33e345ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f12d6ed707c02ea7b51103a7975da37372a68b98b08105d7db6e40781c0b2190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f685a2ec1b236e734834a32e0b267a91dc69b19bdea1b104c043f8cc9eaeb51b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff8b399482be1752fa9c46e9204d9f0aa4410ee4d369ff7e90e3d812a80fe45c"
    sha256 cellar: :any_skip_relocation, ventura:        "c04b55753079d25deef5642ad3d5d41a46d0652c768fb956dec90db36ecd2304"
    sha256 cellar: :any_skip_relocation, monterey:       "ab9be896aa302bd2317968e1cae0834d04594825d5e295535d2ea09e8723935e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a661e89182d6a373e038b012b45c67ddd24aeaf1c66683cecbde0914dd86b572"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comgooglekopkgcommands.Version=#{version}")

    generate_completions_from_executable(bin"ko", "completion")
  end

  test do
    output = shell_output("#{bin}ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}.dockerconfig.json", output
  end
end