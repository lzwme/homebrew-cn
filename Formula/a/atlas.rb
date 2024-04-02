class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.21.0.tar.gz"
  sha256 "34c7429f8cd1e7fa6a26f15996c92d56cae779231f8d837c670cca0daac9f330"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ddf2c720f9d434eb6dd176f353442e5edea3259a9bb46e2b9ca5077f1b9176"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "978cf687f1ddca9d1d22a319c8bf17a51d5a5af5a637a0cbff09e60ee1c26d8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3184aa858893b10596b84efc2ccad22b19848bfa1962f8c7b4c6de384e71201d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e27c86d52c8872fca18a8017b697ebe9d38044774a3c147ace30f71f687f8cd"
    sha256 cellar: :any_skip_relocation, ventura:        "352b7c35c4f0485fdfff16f3cee97c34b07fc7ff5666a7e615028fb61e5870f8"
    sha256 cellar: :any_skip_relocation, monterey:       "4263e0a9cc2b748856ac75fb8e8e9873b5ed87af5781f3f902c39c4ce5cfe2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a0683b105256c1b75a897232658d515acd79867951b01c1371e113dc6dae52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end