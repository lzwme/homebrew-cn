class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.11.tar.gz"
  sha256 "2a2037fda1b166cf002ccfe42802c54cd83d07fd5412061d2266e56a5bbc7148"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a085975a4862146a24d663fcceb5f1b30aaba85c2e5aea9e7b8953707456eb92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db62dcb00ee89c54f914d707fec2f592062c7623c2cbbba88795753f6849df96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e48f4fb32b410f1aaa960c9701f1c54b828b75d7ada4fb575095bc090606db"
    sha256 cellar: :any_skip_relocation, sonoma:         "28118fb7bccb585a93d59120d17b38f030da25745e60153f33d7686590c83843"
    sha256 cellar: :any_skip_relocation, ventura:        "cfd62e4b23a2c7c1628b0bfd7855526f4959a6e75da43794424897eacbb747eb"
    sha256 cellar: :any_skip_relocation, monterey:       "029ae33a9c7f101d273d1d128a21b79449b2dbe6f523638e1ef3e37b2b7036be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d720c3b2b46e745cd79cb04714731b41517f7352460f01d2daf0402e9ac933"
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