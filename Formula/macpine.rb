class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://ghproxy.com/https://github.com/beringresearch/macpine/archive/refs/tags/v0.9.tar.gz"
  sha256 "fbbed218de0037d0fc82bc675fbe89b44202f757f12a5ab53f32ff70345ee1c2"
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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df84e98cc98f316b8fc2ac8850cfd05048bcce9decb5c6fbb15cbf97f04fe520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb9051ac566113476a2e3386f9417bfa0b11f263332476b0f70a0116862baa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0d9dacd246f201cf51fe9033be7032d2485430ede7b41edb58923acbd2a03f8"
    sha256 cellar: :any_skip_relocation, ventura:        "9662303141c80aeb07bc28821701c8a8d88121dd3a0771d531ce3991fcc656f2"
    sha256 cellar: :any_skip_relocation, monterey:       "761d4a26cd28778a902f5687c50173490027b6d94c172d732e5d850eac32795d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d1ae59c1b3ddb9c7d69beaeea2fb5060cea9e8e6f87e3baa26d938a171838d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8e56a36cb50a31021a405272ed01dff9aeb8cab3d16956291b80ee382673b5"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion", base_name: "alpine")
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end