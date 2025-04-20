class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.49.0.tar.gz"
  sha256 "f912a1c55da89818db9566624bfab2547cc6207d7e5296afbe26ddb0a934112b"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9524929bed99c17466cf3659c1b8affa1dcc95daa95501531294ff1980981241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9524929bed99c17466cf3659c1b8affa1dcc95daa95501531294ff1980981241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9524929bed99c17466cf3659c1b8affa1dcc95daa95501531294ff1980981241"
    sha256 cellar: :any_skip_relocation, sonoma:        "f81123f8963b9108936813e0d973bce6bc7396075d159d1e390e7009c6aeacff"
    sha256 cellar: :any_skip_relocation, ventura:       "f81123f8963b9108936813e0d973bce6bc7396075d159d1e390e7009c6aeacff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d09e94d87c849742fb811c59c15794f40a170158847ccda2b95f613c182e30b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua --version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end