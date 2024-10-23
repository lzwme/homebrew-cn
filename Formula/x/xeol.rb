class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https:github.comxeol-ioxeol"
  url "https:github.comxeol-ioxeolarchiverefstagsv0.10.1.tar.gz"
  sha256 "1b88234abe2c3a1a8507d73cdb8a69d702d1b4cbf132e2f34b1fac2acf63250e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd3e80ca52292192638e11010c592fb32f5a9c21f3f3692daed0a12112385ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5983ddd7e65eaaf3fcfd8e47ebb633062024ed0a23cacc63dca8fff8b09da984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f41e6a4a58e186e1026df9037a4b3adbf05d9a5b5d01c285509dd5b5dc518b14"
    sha256 cellar: :any_skip_relocation, sonoma:        "69bb3213fc0ac10c0d1178920bafd8fe6c7e35032cfb687bd66a5063b0fbecd8"
    sha256 cellar: :any_skip_relocation, ventura:       "6233ae913cba3a74fddf09b6b6e32f86c61ff257c74a1edc4e8af94b5082a1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a369ffdb59174b183b75e8992b77e288de42d3ec2d2bb8428194207552efea50"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdxeol"

    generate_completions_from_executable(bin"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xeol version")

    output = shell_output("#{bin}xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end