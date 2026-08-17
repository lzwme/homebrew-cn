class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.709.tar.gz"
  sha256 "91217c8abf572837e31791824af3623f326e02ab5b534893b8cc8c2808cd97a3"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6085b5dbc8546197e9b0b7bc8781a376eba853efc861989be2c206d8ea33f2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08193ad4d4374a17f07938d6b638f6ee6075c8f701d0ccf65fd910ffb8c02cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa16fcef36e445d8e1405371a16ec6350da356cfd3f171bfed315366c9a367c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5c70ae984ae0ce39a5bf0c3e1a8bd98fad1e654b79aabf9be0d1eea4abc582"
    sha256 cellar: :any,                 arm64_linux:   "3d164e771ace3a8ec0416e2e206ba57f48266b3af4f728efbf03c06dc9ac1f3f"
    sha256 cellar: :any,                 x86_64_linux:  "d352fb85dde802791d7b33c7b6f8d77254c1af217ce0095282f32aa2633b448d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end