class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://ghproxy.com/https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "462db8fc69be684b6ff9d91af400739ecd75883c0f42dc3b36e97b5fad869daf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f371b783bc80ad6656b8a9f8105314a018a7e4307306d9c4606b2795f49e041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2e94569f0be071dd7b7455235b69a3c630d61b532bdf1f452b5b31cd0d87df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b12f775a5fe568341267cb2b7c79f0381d58641b6eda3a9de915f1f0f71c29"
    sha256 cellar: :any_skip_relocation, sonoma:         "6abbacc7804b95ce38b4d380355704db470dbbaa383bc8665ecae6baf045b806"
    sha256 cellar: :any_skip_relocation, ventura:        "749fa23b4cbc4312cc25004b07a1a86219b349187b4f285dc428881761847b08"
    sha256 cellar: :any_skip_relocation, monterey:       "ba84173a7a080101b281703632869e7a63074da326062058f050876c432f3f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a6366e93ee3b0aeb4840b97dfe080f07c101ce6f8da3097aacae4574c5fb67"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end