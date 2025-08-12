class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://ghfast.top/https://github.com/beringresearch/macpine/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3a9bfeb723b7f7d24ae6bc4ad3b43b9e040dc0493e53e3c44a3bc1a862052c57"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a513955698efa0fa993365c47881ef01ecdc1a057dd0ebefec57656db92c3464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99cdfb37fb8555b152bacdb9c0bfb9491349819a36e596a759a63ad0000ccf66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5e423975efedc9d23e84189258fdd8a3dd05658a3c0def607204ba313d61637"
    sha256 cellar: :any_skip_relocation, sonoma:        "7262cd25d6fcba73b4e607549624b79253bf36ca711d8bf2367be2a71533c32f"
    sha256 cellar: :any_skip_relocation, ventura:       "05cc0f26bf1e7dcbb49192f2873f85dd06cab52371acdda0e90e4b900a3bd3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc1e72f577aca0a6c5817c54042832eef85db47b756cce32018118e9315c30c"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end