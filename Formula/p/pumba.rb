class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.1.6.tar.gz"
  sha256 "6ff2f276e3984edfd5305712708d2954d0cbb8baea871719270b0475d8f65b0f"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "510d771c45681aff9c0fcbf545e5575580399217284620faa1d8d96d0a6a300f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "510d771c45681aff9c0fcbf545e5575580399217284620faa1d8d96d0a6a300f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "510d771c45681aff9c0fcbf545e5575580399217284620faa1d8d96d0a6a300f"
    sha256 cellar: :any_skip_relocation, sonoma:        "94f814ea1ae868f8418333dd9fb7250003f1916fa9ed41fc20e55ae12ef00b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2881bae911a11cd920d9235eb16e06c99471479f6917daba96e7b389726defd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b7cfd230e29fc54b5a0d63938fe5ecf96de118b321e0d152828b107a9fd125"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end