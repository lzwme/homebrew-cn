class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://ghproxy.com/https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "3e04858d116a8b2dedbd1323ae3b639025647246447315d10981084775cddb70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36ec49279b39c65b2e5059b78c6f1099d9c663f4948fcde1af7df80848df0e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1881ac77fb053fb8d557299b71bd4a6b0049539d44ba2d6975bb82c86b1594cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8dd9cf30334e0bf2036f8155e34d008d118fa7e59cd9060cdc5647ee015eb35"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e2170fd5af7e3a541db3fece9a011623a0df0d38322d42f0fbb4b85dac01ff"
    sha256 cellar: :any_skip_relocation, ventura:        "040ef04cbcdb57d19d655420b23cf5ad79a7911d5c401f649433f11ad91825eb"
    sha256 cellar: :any_skip_relocation, monterey:       "91512550df67308e66f2ef7c13cce696fd1bbab5acc3e55378b0f1889d95fb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7c063c46e933d672f160d76c2b72c637a501ae8734cc3d87cbdb27195f74cd"
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