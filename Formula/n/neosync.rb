class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.18.tar.gz"
  sha256 "37c8323d14f0d3b6c646d96a71b2684b16a4494efefee4b92e2c56066b367143"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93ca1d73a3bb47510a117bd5129e0860e3b3d49a32e9158db56b4c5c9b360dfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2eadc3e1dac2b936d24cf419b309cb27624a0b52eb6db47c5dce5cb54bd6e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb1885c9b7dbdc132c80e6d1b4784dd4169274a11494e9edab8cfe09200fe0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4afa7164c1f918c43678386bc2d750b7fd76ed2ae7189b1cf200a5e29d605739"
    sha256 cellar: :any_skip_relocation, ventura:        "d7272fe27ab0d5bd7cb998261807e9c78f8e8f8485d65f368e6ffdd4a2b2de10"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2a26d723f8a07301f6eca9f705d6d37f19830f50d3c95279ff28e2c150312f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898135ea2eba0e23b12ea27e4c526f0d76f1248dd7e24895f8c02eb5c56b216d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end