class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.3.tar.gz"
  sha256 "0e733b2a42d0e3e6def7339b0ab5f38737474037a878a926614a8312357bb221"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "942e88bbd20a5f133fd32dce52637784339a2ce29f9eeaf38bd327c55f5f4dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "304461b8b43221053f8d1ae8d26aeb0bde537aa910bed8f9637aa90a954dc590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db05ae06cca7a9c46fe1ce322d5270c7efe1a80c35ada64a15decd15a5ba227f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f65211adfbe2a2356732b15bc532b435bba9518a5dd42e4ba9993e14555e0e9"
    sha256 cellar: :any_skip_relocation, ventura:        "5abc2595791b5d3148e683795aa6edf64a1ba57c70aed78c1b91a84b40cfca6b"
    sha256 cellar: :any_skip_relocation, monterey:       "babf4e547c0039da8394d5042e011d4f291f45a1659c4578cf6ebfd0f04346d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c6d2de7de879e3797e80286a550c053466ea3260a24abf4724355cd9a8f14c"
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