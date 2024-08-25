class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.56.tar.gz"
  sha256 "4e62f81ef2d7413f110b23087defb878b9fc10fe5c0eae27191aca526a28d3e2"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca7ecc2d3b9ed714f1bbdff64dad5c7f2bd7f5bcc73e70a424f299249d4e1a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0c35c561d7ee9254fcc784e230629f4b1ee11f161814cb3ba588e318a73d64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ecc285aa22242a863b62850f1f8c2848648bb1eadd2aa31cbba471ac663b48"
    sha256 cellar: :any_skip_relocation, sonoma:         "d56ce01fbc61265498f3763e448b98951b496d4eb67538867a7baa7b6cc0481a"
    sha256 cellar: :any_skip_relocation, ventura:        "090c1b081114aabd8cc0da14ef381ec2523cdd97f384f9dc29aaffc90935e03a"
    sha256 cellar: :any_skip_relocation, monterey:       "23ca0eddaade44d894d72264e8a28d1f43ec39a6e538d4e32734089df23b8841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c57626fd6ef9f1da2699de3b0b02691d8d062abc7c08f5580a76a5fe7a2cc56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end