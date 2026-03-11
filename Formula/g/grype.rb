class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.109.1.tar.gz"
  sha256 "4499ac6dcf84f50b4f05024ba96152cabf343c4a42e9a8366916092f8df49a6d"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa282e73dde1ea98013d377b17718ef0a939bd99725589ba2366888a4b68a3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1612d72df9aa0d9e9017a8288d7e57519d18038dac400353ca2ac43d00b39b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db99be7bb2d9f518baa4bb524ba1ce6c6b15e744e746a3d59f37a6e0aee7b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee68595d7524f3f4fba906553231c5793f501d80c055648b87dc56418d0ec55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74eb3dadd8a6ee5340802cf25774d7092c700a8778666bfeddff7f0fbc734a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d8177d88e285d23fab30d22fff22628588b5f54167069fb9deb6e3feaf55f6c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end