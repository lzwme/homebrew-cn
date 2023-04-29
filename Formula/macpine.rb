class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://ghproxy.com/https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "a86dcebacea9fd26144d7b0470f23198908f5834e29e1ac8ace1265b3a767d66"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69d6f0b3300f8440c653da6ccbf8c2844deb53e33c6745e5870cd1ffb4272635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28657cdfe8f3855d67bad8ad687a31d2d437a867139a6435fbe18dafa4246101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca1ff692beac15edc1bd3b760bf83949001aa5236df42a5c4d5577c4f7f37829"
    sha256 cellar: :any_skip_relocation, ventura:        "8f05cb24965d5184a941f92a11d6bc999e9c9cafded9ce020a0e227feb601ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "509aa3622dbfb104e92823581d4d069d7d0751a3f46948d27b427ba8153f346c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8756fee8e9b2d5cf5f3b1ceccec8ce31853705f5cc52cff700945f6fd0dfe0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d26a43f733b3ad45b0dbb161a32ba037fa1221d42ae36efd7ee0ecd025da882"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion", base_name: "alpine")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end